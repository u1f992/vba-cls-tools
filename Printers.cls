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

''' <summary>
''' プリンタの印刷設定を開く
''' </summary>
''' <param name="strName">プリンタ名</param>
Public Sub ShowSetting(ByVal strName As String)
    If PrinterExists(strName) = False Then
        Err.Raise 1024, "Printers.ShowSetting", "インデックスが有効範囲にありません。"
    End If
    
    Dim objWshShell As Object: Set objWshShell = CreateObject("WScript.Shell")
    objWshShell.Run "rundll32 printui.dll PrintUIEntry /e /n """ & strName & """", 1, True
    Set objWshShell = Nothing
    
End Sub

''' <summary>
''' プリンタの印刷設定を保存する
''' </summary>
''' <param name="strName">プリンタ名</param>
Public Sub SaveSetting(ByVal strName As String)
    If PrinterExists(strName) = False Then
        Err.Raise 1024, "Printers.SaveSetting", "インデックスが有効範囲にありません。"
    End If
    
    Dim objWshShell As Object: Set objWshShell = CreateObject("WScript.Shell")
    Dim strFn As String: strFn = Application.GetSaveAsFilename(InitialFileName:="")
    If strFn = "False" Then
        Set objWshShell = Nothing
        Exit Sub
    End If
    
    Dim fso As Object: Set fso = CreateObject("Scripting.FileSystemObject")
    If fso.FileExists(strFn) = True Then
        fso.GetFile(strFn).Delete True
    End If
    
    objWshShell.Run "rundll32 printui.dll PrintUIEntry /Ss /n """ & strName & """ /a """ & strFn & """", 1, True
    Set objWshShell = Nothing
    Set fso = Nothing
    
End Sub

''' <summary>
''' プリンタの印刷設定を復元する
''' </summary>
''' <param name="strName">プリンタ名</param>
Public Sub RestoreSetting(ByVal strName As String)
    If PrinterExists(strName) = False Then
        Err.Raise 1024, "Printers.SaveSetting", "インデックスが有効範囲にありません。"
    End If
    
    Dim objWshShell As Object: Set objWshShell = CreateObject("WScript.Shell")
    Dim strFn As String: strFn = Application.GetOpenFilename
    If strFn = "False" Then
        Set objWshShell = Nothing
        Exit Sub
    End If
    
    Dim fso As Object: Set fso = CreateObject("Scripting.FileSystemObject")
    If fso.FileExists(strFn) = False Then
        Set objWshShell = Nothing
        Set fso = Nothing
        Exit Sub
    End If
    
    objWshShell.Run "rundll32 printui.dll PrintUIEntry /Sr /n """ & strName & """ /a """ & strFn & """ u", 1, True
    Set objWshShell = Nothing
    Set fso = Nothing
    
End Sub

''' <summary>
''' 指定したプリンタ名が登録されているか確認する
''' </summary>
''' <param name="strName">検索するプリンタ名</param>
Public Function PrinterExists(ByVal strName As String) As Boolean
    Dim i As Long
    For i = 0 To Length - 1
        If prtList(i) = strName Then
            PrinterExists = True
            Exit Function
        End If
    Next i
    
    PrinterExists = False
    
End Function
