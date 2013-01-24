--挂失卡[必须有原卡号, 新卡号]
--返回值 含义 
--0 成功执行。 
--101 卡号不能为空 
--102 卡号必须大于100, 小于 4294967295
--103 卡号已被其他人使用
--104 卡号不存在
--201 用户姓名不能为空 
--301 部门班组名必须是已存在的
--9 SQL Server errors

CREATE PROCEDURE sp_wg_RegisterLostCard
@CardNO bigint,
@NewCardNO bigint
AS
DECLARE @reccount as int
DECLARE @consumerID  as int  
-- Validate parameter.
IF @CardNO IS NULL
BEGIN
   PRINT 'ERROR: You must specify a CardNO value.'
   RETURN(101)
END
ELSE
BEGIN
--必须是整数 且小于4294967295, 大于100
IF (@CardNO <= 100 OR @CardNO >= 4294967295 )
	RETURN(102)
END

IF @NewCardNO IS NULL
BEGIN
   PRINT 'ERROR: You must specify a NewCardNO value.'
   RETURN(101)
END
ELSE
BEGIN
--必须是整数 且小于4294967295, 大于100
IF (@NewCardNO <= 100 OR @NewCardNO >= 4294967295 )
	RETURN(102)
END


--查找卡对应的用户
SELECT @consumerID= f_ConsumerID from [t_b_IDCard] where [f_CardNO]= @CardNO
IF @consumerID IS NULL
	RETURN(104)

--查新卡号是否在用
SELECT @reccount=count(*) FROM t_b_IDCard 
WHERE f_CardStatusDesc='0' 
   AND f_CardNO= @NewCardNO 

IF @reccount >0
	--新卡号正在使用, 不能作挂失操作 
   RETURN(103)

BEGIN TRANSACTION

--挂失原有卡
Update [t_b_IDCard]
SET [f_CardStatusDesc]= '已挂失'
WHERE [f_CardNo]= @CardNO 

--持卡人原持有的卡全作挂失
Update [t_b_IDCard]
SET [f_CardStatusDesc]= '已挂失'
WHERE [f_ConsumerID]= @consumerID


--清指定的新卡
DELETE FROM [t_b_IDCard]
WHERE  [f_CardNo]=@NewCardNO

--添加新卡
Insert Into [t_b_IDCard] ([f_Cardno], [f_ConsumerID], [f_CardStatusDesc])
values (@NewCardNO, @consumerID, '0')

COMMIT TRANSACTION
                                
RETURN(0)

GO

