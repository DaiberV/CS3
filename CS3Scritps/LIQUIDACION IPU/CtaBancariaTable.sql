/****** Object:  Table [dbo].[GRL_CargueCtaBancaria]    Script Date: 01/04/2017 11:04:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[GRL_CargueCtaBancaria](
	[CgrCueItm] [decimal](10, 0) IDENTITY(1,1) NOT NULL,
	[CgrCueCod] [char](30) NOT NULL,
	[CgrCueDes] [varchar](500) NOT NULL,
	[CgrCueBcoCod] [smallint] NOT NULL,
	[CgrCueTerCod] [decimal](15, 0) NOT NULL,
	[CgrCueFueCod] [smallint] NOT NULL,
	[CgrCueEst] [char](20) NOT NULL,
	[CgrCuePucCod] [char](30) NOT NULL,
	[CgrCueErr] [varchar](1000) NOT NULL,
	[AnoCod] [smallint] NOT NULL,
	[LcgCod] [decimal](10, 0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CgrCueItm] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


