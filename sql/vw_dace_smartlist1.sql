USE [MEX10]
GO

/****** Object:  View [dbo].[vw_dace_smartlist1]    Script Date: 12/06/2018 18:01:37 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_dace_smartlist1]'))
DROP VIEW [dbo].[vw_dace_smartlist1]
GO

USE [MEX10]
GO

/****** Object:  View [dbo].[vw_dace_smartlist1]    Script Date: 12/06/2018 18:01:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_dace_smartlist1]
AS
SELECT     m.CNTRLTYP, m.DOCTYPE, m.CNTRLNUM, m.DOCNUMBR, m.DOCDATE, m.VENDORID, a.DOCAMNT, a.CURNCYID, a.TRXDSCRN, 
                      CASE m.DOCTYPE WHEN 6 THEN CASE WHEN MAX(CFDIA.METODOPAGO) = 'PUE' AND MAX(isnull(asoc.MexFolioFiscal, '')) = '' THEN MAX(APLICADO.MexFolioFiscal) 
                      ELSE MAX(asoc.MexFolioFiscal) END ELSE MAX(asoc.MexFolioFiscal) END AS CFDI_ASOC, CASE m.DOCTYPE WHEN 1 THEN CASE WHEN (CFDI.METODOPAGO) 
                      = 'PUE' THEN MAX(asoc.MexFolioFiscal) ELSE MAX(aplicado.MexFolioFiscal) END WHEN 6 THEN CASE WHEN (CFDIa.METODOPAGO) 
                      = 'PUE' THEN MAX(aplicado.MexFolioFiscal) ELSE MAX(aplicado.MexFolioFiscal) END END AS CFDI_Apli, ISNULL(CFDI.METODOPAGO, '') AS MetodoPago, 
                      CFDIA.METODOPAGO AS cfdia_metodopago, CASE WHEN CFDI.METODOPAGO = 'PUE' OR
                      CFDIA.METODOPAGO = 'PUE' THEN CASE WHEN m.DOCTYPE = 1 AND ISNULL(MAX(aplicado.MexFolioFiscal), '') = '' AND MAX(a.DocAplic) IS NOT NULL 
                      THEN 'CFDI SE APLICO OK' ELSE CASE WHEN m.DOCTYPE = 6 AND ISNULL(MAX(asoc.MexFolioFiscal), '') 
                      = '' THEN 'CFDI SE APLICO OK' ELSE 'CFDI SE APLICO ERRADO' END END ELSE CASE WHEN MIN(dbo.fun_DACE_ValidarAplica(CASE m.DOCTYPE WHEN 1 THEN aplicado.MexFolioFiscal
                       WHEN 6 THEN asoc.MexFolioFiscal END, CASE m.DOCTYPE WHEN 1 THEN asoc.MexFolioFiscal WHEN 6 THEN aplicado.MexFolioFiscal END)) 
                      > 0 THEN 'CFDI SE APLICO OK' ELSE 'CFDI SE APLICO ERRADO' END END AS OBSERVACIONES, m.DCSTATUS
FROM         dbo.PM00400 AS m LEFT OUTER JOIN
                          (SELECT     o.VCHRNMBR, o.VENDORID, o.DOCTYPE, o.DOCDATE, o.DOCNUMBR, o.DOCAMNT, o.CURTRXAM, o.TRXDSCRN, o.VOIDED, o.CURNCYID, 
                                                   'OPEN' AS ESTATUS, CASE o.DOCTYPE WHEN 6 THEN B.APTVCHNM WHEN 1 THEN B.VCHRNMBR END AS DocAplic, 
                                                   CASE o.DOCTYPE WHEN 6 THEN B.APTODCTY WHEN 1 THEN B.DOCTYPE END AS DocTipoAplic
                            FROM          dbo.PM20000 AS o LEFT OUTER JOIN
                                                   dbo.PM20100 AS B ON CASE o.DOCTYPE WHEN 6 THEN B.DOCTYPE WHEN 1 THEN B.APTODCTY END = o.DOCTYPE AND 
                                                   CASE o.DOCTYPE WHEN 6 THEN B.VCHRNMBR WHEN 1 THEN B.APTVCHNM END = o.VCHRNMBR
                            UNION
                            SELECT     o.VCHRNMBR, o.VENDORID, o.DOCTYPE, o.DOCDATE, o.DOCNUMBR, o.DOCAMNT, o.CURTRXAM, o.TRXDSCRN, o.VOIDED, o.CURNCYID, 
                                                  'HIST' AS ESTATUS, CASE o.DOCTYPE WHEN 6 THEN B.APTVCHNM WHEN 1 THEN B.VCHRNMBR END AS Expr1, 
                                                  CASE o.DOCTYPE WHEN 6 THEN B.APTODCTY WHEN 1 THEN B.DOCTYPE END AS Expr2
                            FROM         dbo.PM30200 AS o LEFT OUTER JOIN
                                                  dbo.PM30300 AS B ON CASE o.DOCTYPE WHEN 6 THEN B.DOCTYPE WHEN 1 THEN B.APTODCTY END = o.DOCTYPE AND 
                                                  CASE o.DOCTYPE WHEN 6 THEN B.VCHRNMBR WHEN 1 THEN B.APTVCHNM END = o.VCHRNMBR) AS a ON m.DOCTYPE = a.DOCTYPE AND 
                      m.CNTRLNUM = a.VCHRNMBR LEFT OUTER JOIN
                      dbo.ACA_IETU00400 AS asoc ON asoc.DOCTYPE = a.DOCTYPE AND asoc.VCHRNMBR = a.VCHRNMBR LEFT OUTER JOIN
                      dbo.ACA_IETU00400 AS aplicado ON aplicado.DOCTYPE = a.DocTipoAplic AND aplicado.VCHRNMBR = a.DocAplic LEFT OUTER JOIN
                      dace.ComprobanteCFDI AS CFDI ON CFDI.TIPOCOMPROBANTE = CASE M.DOCTYPE WHEN 6 THEN 'P' WHEN 1 THEN 'I' END AND 
                      CFDI.UUID = asoc.MexFolioFiscal LEFT OUTER JOIN
                      dace.ComprobanteCFDI AS CFDIA ON CFDIA.TIPOCOMPROBANTE = CASE M.DOCTYPE WHEN 6 THEN 'I' END AND CFDIA.UUID = aplicado.MexFolioFiscal
WHERE     (a.VOIDED = 0)
GROUP BY m.DOCTYPE, m.CNTRLNUM, m.DOCNUMBR, m.DOCDATE, m.VENDORID, a.DOCAMNT, a.CURNCYID, a.TRXDSCRN, asoc.MexFolioFiscal, CFDI.METODOPAGO, 
                      CFDIA.METODOPAGO, m.DCSTATUS, m.CNTRLTYP

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[65] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 5
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "m"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 210
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 248
               Bottom = 114
               Right = 399
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "asoc"
            Begin Extent = 
               Top = 6
               Left = 458
               Bottom = 114
               Right = 609
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aplicado"
            Begin Extent = 
               Top = 6
               Left = 865
               Bottom = 114
               Right = 1016
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CFDI"
            Begin Extent = 
               Top = 6
               Left = 647
               Bottom = 114
               Right = 827
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CFDIA"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 218
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 79
         Width = 284
         Width = 1500
         Width = 1500
        ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_dace_smartlist1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' Width = 1575
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1980
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_dace_smartlist1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_dace_smartlist1'
GO

