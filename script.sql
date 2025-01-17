USE [Mock]
GO
/****** Object:  StoredProcedure [dbo].[customed]    Script Date: 5/8/2018 4:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[customed]  
AS  
BEGIN 
SELECT cart.cart_id,demo.name,demo.dob,demo.Address,demo.email,demo.Phone,CART.date,COUNT(cart.quantity) as Total_Quantity, sum(cart.total) as Total_Price
FROM demo 
INNER JOIN cart 
ON demo.id = cart.cart_id  
group by
demo.name,demo.dob,demo.Address,demo.email,demo.Phone,cart.cart_id,CART.date
END





GO
/****** Object:  Table [dbo].[cart]    Script Date: 5/8/2018 4:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cart](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[product_id] [int] NULL,
	[id] [int] NULL,
	[date] [date] NULL,
	[quantity] [int] NULL,
	[total] [float] NULL,
 CONSTRAINT [PK_cart] PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[demo]    Script Date: 5/8/2018 4:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[demo](
	[id] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[Address] [varchar](50) NULL,
	[Phone] [nchar](10) NULL,
	[email] [varchar](50) NULL,
	[dob] [date] NULL,
	[fav_color] [varchar](50) NULL,
 CONSTRAINT [PK_demo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[prodemo]    Script Date: 5/8/2018 4:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[prodemo](
	[product_id] [int] NOT NULL,
	[product_name] [varchar](200) NULL,
	[description] [text] NULL,
	[price] [int] NULL,
	[quantity] [int] NULL,
 CONSTRAINT [PK_prodemo] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD  CONSTRAINT [FK_cart_demo] FOREIGN KEY([id])
REFERENCES [dbo].[demo] ([id])
GO
ALTER TABLE [dbo].[cart] CHECK CONSTRAINT [FK_cart_demo]
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD  CONSTRAINT [FK_cart_pro] FOREIGN KEY([product_id])
REFERENCES [dbo].[prodemo] ([product_id])
GO
ALTER TABLE [dbo].[cart] CHECK CONSTRAINT [FK_cart_pro]
GO
