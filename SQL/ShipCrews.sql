USE [master]
GO
/****** Object:  Database [ShipCrews]    Script Date: 05/07/2024 13:57:12 ******/
CREATE DATABASE [ShipCrews]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ShipCrews', FILENAME = N'C:\Program Files\Microsoft SQL Server 2022\MSSQL16.SQLEXPRESS\MSSQL\DATA\ShipCrews.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ShipCrews_log', FILENAME = N'C:\Program Files\Microsoft SQL Server 2022\MSSQL16.SQLEXPRESS\MSSQL\DATA\ShipCrews_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ShipCrews] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ShipCrews].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ShipCrews] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ShipCrews] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ShipCrews] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ShipCrews] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ShipCrews] SET ARITHABORT OFF 
GO
ALTER DATABASE [ShipCrews] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ShipCrews] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ShipCrews] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ShipCrews] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ShipCrews] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ShipCrews] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ShipCrews] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ShipCrews] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ShipCrews] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ShipCrews] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ShipCrews] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ShipCrews] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ShipCrews] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ShipCrews] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ShipCrews] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ShipCrews] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ShipCrews] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ShipCrews] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ShipCrews] SET  MULTI_USER 
GO
ALTER DATABASE [ShipCrews] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ShipCrews] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ShipCrews] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ShipCrews] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ShipCrews] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ShipCrews] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [ShipCrews] SET QUERY_STORE = ON
GO
ALTER DATABASE [ShipCrews] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [ShipCrews]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCrewRoleCountFunc]    Script Date: 05/07/2024 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	   CREATE FUNCTION [dbo].[GetCrewRoleCountFunc] 
		(@CrewId INT, @RoleId INT)
		RETURNS INT
		AS
		BEGIN
			DECLARE @Result AS INT=0
			SET @Result = (SELECT COUNT(*) FROM CrewAssignments c, People  p WHERE c.PersonId = p.PersonId AND p.RoleId = @RoleId AND c.CrewId = @CrewId)
			RETURN @Result
		END
GO
/****** Object:  Table [dbo].[People]    Script Date: 05/07/2024 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[People](
	[PersonId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[RoleId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CrewAssignments]    Script Date: 05/07/2024 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CrewAssignments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CrewId] [int] NULL,
	[PersonId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [CK_CrewAssignments_Unique] UNIQUE NONCLUSTERED 
(
	[CrewId] ASC,
	[PersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[NeverAssignedPeople]    Script Date: 05/07/2024 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


	   ---------------------------------------------------
       -- Create a view 'NeverAssignedPeople'
	   CREATE VIEW [dbo].[NeverAssignedPeople] AS
			SELECT p.FirstName, p.LastName
			FROM People p
			WHERE p.PersonId NOT IN (SELECT PersonId FROM CrewAssignments)


		-- SELECT * FROM NeverAssignedPeople
		-- SELECT * FROM CrewAssignments
		-- SELECT * FROM People
		-- SELECT PersonId FROM CrewAssignments
		-- SELECT p.FistName, p.LastName
			-- FROM People p 
			-- WHERE p.PersonId NOT IN (3)
		-- SELECT *
			-- FROM People p 
			-- WHERE p.PersonId NOT IN (SELECT PersonId FROM CrewAssignments)
GO
/****** Object:  Table [dbo].[Crews]    Script Date: 05/07/2024 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Crews](
	[CrewId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[CrewId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 05/07/2024 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RoleId] [int] NOT NULL,
	[Name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CrewAssignments]  WITH CHECK ADD FOREIGN KEY([CrewId])
REFERENCES [dbo].[Crews] ([CrewId])
GO
ALTER TABLE [dbo].[CrewAssignments]  WITH CHECK ADD FOREIGN KEY([PersonId])
REFERENCES [dbo].[People] ([PersonId])
GO
ALTER TABLE [dbo].[People]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([RoleId])
GO
ALTER TABLE [dbo].[CrewAssignments]  WITH CHECK ADD  CONSTRAINT [CheckSkipper] CHECK  (([dbo].[GetCrewRoleCountFunc]([CrewId],(1))<=(1)))
GO
ALTER TABLE [dbo].[CrewAssignments] CHECK CONSTRAINT [CheckSkipper]
GO
USE [master]
GO
ALTER DATABASE [ShipCrews] SET  READ_WRITE 
GO
