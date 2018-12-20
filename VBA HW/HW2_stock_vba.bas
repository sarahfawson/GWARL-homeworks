Attribute VB_Name = "Module1"
Sub HW2VBA()

    ' declare  variables
    Dim WS As Worksheet

    
    ' Start loop through worksheets
    For Each WS In ActiveWorkbook.Worksheets
    WS.Activate
        
        'set summary table up and declare titles

        Cells(1, 9).Value = "Ticker"
        Cells(1, 10).Value = "Yearly Change"
        Cells(1, 11).Value = "Percentage Change"
        Cells(1, 12).Value = "Total Stock Volume"
               
        'Declare variables
        Dim ticker As String
        Dim yearly_change As Double
        Dim volume As Double
            volume = 0
        Dim percent_change As Double
        Dim open_price As Double
            open_price = Cells(2, 3).Value
        Dim close_price As Double
        Dim Summary_Table_Row As Integer
            Summary_Table_Row = 2
        Dim i As Long
        
        'find last row and start loop
        lastrow = Cells(Rows.Count, 1).End(xlUp).Row
        For i = 2 To lastrow

        
          ' Check if next ticker is the same as current ticker labeled "i"
            If Cells(i + 1, 1).Value <> Cells(i, 1).Value Then

                ' Set the Ticker Value and print in table
                ticker = Cells(i, 1).Value
                Cells(Summary_Table_Row, 9).Value = ticker
                
                'set jan 1 closing price for the ticker
                close_price = Cells(i, 6).Value
                
                'calculate yearly price change
                yearly_change = close_price - open_price
                Cells(Summary_Table_Row, 10).Value = yearly_change
                
                'calculate percent change
                If (open_price = 0 And close_price = 0) Then
                    percent_change = 0
                    
                    ElseIf (open_price = 0 And close_price <> 0) Then
                        percent_change = 1
                    Else
                        percent_change = (yearly_change / open_price)
                        Cells(Summary_Table_Row, 11).Value = percent_change
                        Cells(Summary_Table_Row, 11).NumberFormat = "0.00%"
                End If
                
                'Add Total Stock Volume
                volume = volume + Cells(i, 7).Value
                Cells(Summary_Table_Row, 12).Value = volume
                   
                ' Add one to the summary table row to set up for the next ticker paste
                Summary_Table_Row = Summary_Table_Row + 1
                
                'reset open price
                open_price = Cells(i + 1, 3).Value

                ' Reset Total Stock Volume
                volume = 0
            
                'if cells ARE the same ticker
                Else
                volume = volume + Cells(i, 7).Value

            End If
              
        Next i


        'conditional formatting to the yearly change column with a loop
        YC_lastrow = Cells(Rows.Count, 10).End(xlUp).Row
        For j = 2 To YC_lastrow
        
            'set the colors of the conditional formatting
            If Cells(j, 10).Value >= 0 Then
                Cells(j, 10).Interior.ColorIndex = 10
            ElseIf Cells(j, 10).Value < 0 Then
                Cells(j, 10).Interior.ColorIndex = 3
            End If
        Next j
        
        'declare variables for bonus
        'Cells(1, 14).Value = "Ticker"
        'Cells(1, 15).Value = "Value"
        'Cells(2, 13).Value = "Greatest % Increase"
        'Cells(3, 13).Value = "Greatest % Decrease"
        'Cells(4, 13).Value = "Greatest total volume"
        
        'Dim greatest_increase As Double
        'Dim greatest_decrease As Double
        'Dim greatest_vol As Double
        'Dim bonus_table_row As Integer
            'bonus_table_row = 2
            
        'find last row of summary table and start loop for bonus table

        
    Next WS

End Sub

