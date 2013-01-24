--////////////////////////////////////////////////////////////////////////////////////
--创建历史购电记录表
--////////////////////////////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[kd_his] (
	[rec_no] [int] NOT NULL ,
	[buyer_id] [char] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[xiaoqu_id] [int] NULL ,
	[room_id] [int] NULL ,
	[tranamt] [float] NULL ,
	[endatatime] [datetime] NULL ,
	[custsn] [char] (20) COLLATE Chinese_PRC_CI_AS NULL ,
        [getTime] [datetime] NULL ,
        [sendTime] [datetime] NULL
) ON [PRIMARY]
GO

--////////////////////////////////////////////////////////////////////////////////////
--创建房间信息表
--////////////////////////////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[kd_room] (
	[xiaoqu] [char] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[xiaoqu_id] [int] NOT NULL ,
	[loudong] [char] (100) COLLATE Chinese_PRC_CI_AS NULL ,
	[loudong_id] [int] NOT NULL ,
	[room] [char] (12) COLLATE Chinese_PRC_CI_AS NULL ,
	[room_id] [int] NULL ,
	[usedAmp] [float] NULL ,
	[allAmp] [float] NULL 
) ON [PRIMARY]
GO

--////////////////////////////////////////////////////////////////////////////////////
--创建临时购电记录表
--////////////////////////////////////////////////////////////////////////////////////
CREATE TABLE [dbo].[kd_tmp] (
	[rec_no] [int] IDENTITY (1, 1) NOT NULL ,
	[buyer_id] [char] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[xiaoqu_id] [int] NULL ,
	[room_id] [int] NULL ,
	[tranamt] [float] NULL ,
	[endatatime] [datetime] NULL ,
	[custsn] [char] (20) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--////////////////////////////////////////////////////////////////////////////////////
--向临时表写入购电数据
--////////////////////////////////////////////////////////////////////////////////////
CREATE PROCEDURE SP_KDDB_POSTFEE
    @RSULT        int OUTPUT,
    @B_ID           int,
    @XQ_ID        int,
    @R_ID          int,
    @FEE           float,
    @DT            datetime,
   @CSN          char(20)
AS
BEGIN
    DECLARE @TR int
    SET @TR=0
    BEGIN TRANSACTION
        INSERT KD_TMP     
            VALUES (@B_ID, @XQ_ID, @R_ID, @FEE, @DT, @CSN)
        SET @TR=1
    COMMIT TRANSACTION
    SET @RSULT=@TR
END
GO
