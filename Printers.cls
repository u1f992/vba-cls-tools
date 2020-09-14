VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Printers"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

''' プリンタ一覧を取得するモジュール
''' <example>
'''
''' 宣言例
''' <code>
''' Dim clsPrinters As New Printers
''' </code>
'''
''' 利用可能なプリンタの一覧をForループで表示する例
''' <code>
''' Dim i As Long
''' For i = 0 To clsPrinters.Length - 1
'''     Debug.Print clsPrinters.Items(i)
''' Next i
''' </code>
''' </example>

''' <summary>
''' プリンタ名一覧を格納する配列
''' </summary>
Private prtList() As String

''' <summary>
''' プリンタ名を取得する
''' </summary>
''' <param name="index">要素 0~(Length - 1)</param>
Public Property Get Items(ByVal index As Long) As String
    If LBound(prtList) > index Or UBound(prtList) < index Then
        Err.Raise 1024, "Printers.Items", "インデックスが有効範囲にありません。"
    Else
        Items = prtList(index)
    End If
End Property

''' <summary>
''' Itemsプロパティの要素数
''' </summary>
Public Property Get Length() As Long
    Length = UBound(prtList) + 1
End Property

Private Sub Class_Initialize()
    Refresh
End Sub

''' <summary>
''' プリンタ名一覧を再構築する
''' </summary>
Public Sub Refresh()
    ReDim prtList(0)
    Dim flag As Boolean: flag = False
    
    Dim objShell As Object: Set objShell = CreateObject("Shell.Application")
    Const ssfPRINTERS = 4
    
    Dim obj As Object
    For Each obj In objShell.Namespace(ssfPRINTERS).Items
    
        If flag = False Then ' 添え字0に追加する
            flag = True
        Else
            ReDim Preserve prtList(UBound(prtList) + 1)
        End If
        
        prtList(UBound(prtList)) = obj.Name
        
    Next obj
    
    Set objShell = Nothing
    
End Sub

''' <summary>
''' 組み込みダイアログを表示する
''' </summary>
Public Sub ShowDialog()
    Application.Dialogs(xlDialogPrinterSetup).Show
End Sub
