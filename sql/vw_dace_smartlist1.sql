/****** Object:  View [dbo].[vw_dace_smartlist1]    Script Date: 10/24/2018 16:38:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_dace_smartlist1]
AS
SELECT     a.DCSTATUS, e.ESTATUS, CASE a.doctype WHEN 1 THEN 'Factura' WHEN 6 THEN 'Pago' END AS tipo, a.DOCTYPE, a.CNTRLNUM, a.DOCNUMBR, a.DOCDATE, 
                      a.VENDORID, e.DOCAMNT, e.CURNCYID, CFDI.FORMAPAGO, B.MexFolioFiscal AS CFDI_ASOCIADO, B1.MexFolioFiscal AS CFDI_APLICADO, 
                      CASE A.DOCTYPE WHEN 1 THEN OK.CFDI_UUID WHEN 6 THEN OK.UUIDRELACIONADO END AS CFDI_APLICAR, 
                      CASE WHEN CASE A.DOCTYPE WHEN 1 THEN OK.CFDI_UUID WHEN 6 THEN OK.UUIDRELACIONADO END = B1.MexFolioFiscal THEN 'APLICACION CORRECTA' ELSE 'APLICACION INCORRECTA'
                       END AS OBSERVACIONES
FROM         dbo.PM00400 AS a LEFT OUTER JOIN
                          (SELECT     VCHRNMBR, VENDORID, DOCTYPE, DOCDATE, DOCNUMBR, DOCAMNT, CURTRXAM, DISTKNAM, DISCAMNT, DSCDLRAM, BACHNUMB, TRXSORCE, 
                                                   BCHSOURC, DISCDATE, DUEDATE, PORDNMBR, TEN99AMNT, WROFAMNT, DISAMTAV, TRXDSCRN, UN1099AM, BKTPURAM, BKTFRTAM, BKTMSCAM, 
                                                   VOIDED, HOLD, CHEKBKID, DINVPDOF, PPSAMDED, PPSTAXRT, PGRAMSBJ, GSTDSAMT, POSTEDDT, PTDUSRID, MODIFDT, MDFUSRID, PYENTTYP, 
                                                   CARDNAME, PRCHAMNT, TRDISAMT, MSCCHAMT, FRTAMNT, TAXAMNT, TTLPYMTS, CURNCYID, PYMTRMID, SHIPMTHD, TAXSCHID, PCHSCHID, 
                                                   FRTSCHID, MSCSCHID, PSTGDATE, DISAVTKN, CNTRLTYP, NOTEINDX, PRCTDISC, RETNAGAM, ICTRX, Tax_Date, PRCHDATE, CORRCTN, SIMPLIFD, 
                                                   BNKRCAMT, APLYWITH, Electronic, ECTRX, DocPrinted, TaxInvReqd, VNDCHKNM, BackoutTradeDisc, CBVAT, VADCDTRO, TEN99TYPE, 
                                                   TEN99BOXNUMBER, PONUMBER, DEX_ROW_TS, DEX_ROW_ID, 'OPEN' AS ESTATUS, '' AS CFDI_APLICADO, 0 AS CFDI_D
                            FROM          dbo.PM20000 AS o
                            UNION
                            SELECT     A1.VCHRNMBR, A1.VENDORID, A1.DOCTYPE, A1.DOCDATE, A1.DOCNUMBR, A1.DOCAMNT, A1.CURTRXAM, A1.DISTKNAM, A1.DISCAMNT, A1.DSCDLRAM, 
                                                  A1.BACHNUMB, A1.TRXSORCE, A1.BCHSOURC, A1.DISCDATE, A1.DUEDATE, A1.PORDNMBR, A1.TEN99AMNT, A1.WROFAMNT, A1.DISAMTAV, 
                                                  A1.TRXDSCRN, A1.UN1099AM, A1.BKTPURAM, A1.BKTFRTAM, A1.BKTMSCAM, A1.VOIDED, A1.HOLD, A1.CHEKBKID, A1.DINVPDOF, A1.PPSAMDED, 
                                                  A1.PPSTAXRT, A1.PGRAMSBJ, A1.GSTDSAMT, A1.POSTEDDT, A1.PTDUSRID, A1.MODIFDT, A1.MDFUSRID, A1.PYENTTYP, A1.CARDNAME, 
                                                  A1.PRCHAMNT, A1.TRDISAMT, A1.MSCCHAMT, A1.FRTAMNT, A1.TAXAMNT, A1.TTLPYMTS, A1.CURNCYID, A1.PYMTRMID, A1.SHIPMTHD, A1.TAXSCHID, 
                                                  A1.PCHSCHID, A1.FRTSCHID, A1.MSCSCHID, A1.PSTGDATE, A1.DISAVTKN, A1.CNTRLTYP, A1.NOTEINDX, A1.PRCTDISC, A1.RETNAGAM, A1.VOIDPDATE, 
                                                  A1.ICTRX, A1.Tax_Date, A1.PRCHDATE, A1.CORRCTN, A1.SIMPLIFD, A1.APLYWITH, A1.Electronic, A1.ECTRX, A1.DocPrinted, A1.TaxInvReqd, 
                                                  A1.VNDCHKNM, A1.BackoutTradeDisc, A1.CBVAT, A1.VADCDTRO, A1.TEN99TYPE, A1.TEN99BOXNUMBER, A1.PONUMBER, A1.DEX_ROW_TS, 
                                                  A1.DEX_ROW_ID, 'HIST' AS Expr1, ISNULL(B.APTVCHNM, B1.VCHRNMBR) AS Expr2, ISNULL(B.APTODCTY, B1.DOCTYPE) AS Expr3
                            FROM         dbo.PM30200 AS A1 LEFT OUTER JOIN
                                                  dbo.PM30300 AS B ON B.DOCTYPE = A1.DOCTYPE AND B.VCHRNMBR = A1.VCHRNMBR LEFT OUTER JOIN
                                                  dbo.PM30300 AS B1 ON B1.APTODCTY = A1.DOCTYPE AND B1.APTVCHNM = A1.VCHRNMBR) AS e ON e.DOCTYPE = a.DOCTYPE AND 
                      e.VCHRNMBR = a.CNTRLNUM LEFT OUTER JOIN
                      dbo.ACA_IETU00400 AS B ON B.DOCTYPE = a.DOCTYPE AND B.VCHRNMBR = a.CNTRLNUM LEFT OUTER JOIN
                      dace.ComprobanteCFDI AS CFDI ON CFDI.TIPOCOMPROBANTE = CASE B.DOCTYPE WHEN 1 THEN '1' WHEN 6 THEN 'P' END AND 
                      CFDI.UUID = B.MexFolioFiscal LEFT OUTER JOIN
                      dbo.ACA_IETU00400 AS B1 ON B1.DOCTYPE = e.CFDI_D AND B1.VCHRNMBR = e.CFDI_APLICADO LEFT OUTER JOIN
                      dace.ComprobanteCFDIRelacionado AS OK ON CASE A.DOCTYPE WHEN 1 THEN OK.UUIDRELACIONADO WHEN 6 THEN OK.CFDI_UUID END = B.MexFolioFiscal
WHERE     (e.VOIDED = 0)

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
         Configuration = "(H (2[33] 3) )"
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
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 210
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 248
               Bottom = 114
               Right = 420
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 6
               Left = 458
               Bottom = 114
               Right = 609
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
         Begin Table = "B1"
            Begin Extent = 
               Top = 6
               Left = 865
               Bottom = 114
               Right = 1016
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OK"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 207
               Right = 248
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
         Width = 150' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_dace_smartlist1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'0
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
      Begin ColumnWidths = 11
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

