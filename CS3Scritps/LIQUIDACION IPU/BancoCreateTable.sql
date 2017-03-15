
/****** Object:  Table [dbo].[GRL_CargueBanco]    Script Date: 01/04/2017 11:02:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[GRL_CargueBanco](
	[CgrBcoItm] [decimal](10, 0) IDENTITY(1,1) NOT NULL,
	[CgrBcoCod] [smallint] NOT NULL,
	[CgrBcoNom] [char](120) NOT NULL,
	[CgrBcoSiaCod] [char](20) NOT NULL,
	[CgrBcoSupCod] [smallint] NOT NULL,
	[CgrBcoEst] [char](20) NOT NULL,
	[CgrBcoErr] [varchar](1000) NOT NULL,
	[AnoCod] [smallint] NOT NULL,
	[LcgCod] [decimal](10, 0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CgrBcoItm] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[GRL_CargueBanco]  WITH CHECK ADD  CONSTRAINT [ICARGUEBANCO1] FOREIGN KEY([AnoCod], [LcgCod])
REFERENCES [dbo].[GRL_LoteInformacion] ([AnoCod], [LcgCod])
GO

ALTER TABLE [dbo].[GRL_CargueBanco] CHECK CONSTRAINT [ICARGUEBANCO1]
GO


