<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MainForm
  Inherits System.Windows.Forms.Form

  'Das Formular überschreibt den Löschvorgang, um die Komponentenliste zu bereinigen.
  <System.Diagnostics.DebuggerNonUserCode()> _
  Protected Overrides Sub Dispose(ByVal disposing As Boolean)
    Try
      If disposing AndAlso components IsNot Nothing Then
        components.Dispose()
      End If
    Finally
      MyBase.Dispose(disposing)
    End Try
  End Sub

  'Wird vom Windows Form-Designer benötigt.
  Private components As System.ComponentModel.IContainer

  'Hinweis: Die folgende Prozedur ist für den Windows Form-Designer erforderlich.
  'Das Bearbeiten ist mit dem Windows Form-Designer möglich.  
  'Das Bearbeiten mit dem Code-Editor ist nicht möglich.
  <System.Diagnostics.DebuggerStepThrough()> _
  Private Sub InitializeComponent()
        Me.guiHalt = New System.Windows.Forms.Button()
        Me.guiExtension = New System.Windows.Forms.TextBox()
        Me.guiLoad = New System.Windows.Forms.TextBox()
        Me.guiPosition = New System.Windows.Forms.TextBox()
        Me.guiDebug = New System.Windows.Forms.RichTextBox()
        Me.lblExtension = New System.Windows.Forms.Label()
        Me.lblDestinationUnit = New System.Windows.Forms.Label()
        Me.lblLoad = New System.Windows.Forms.Label()
        Me.guiOn = New System.Windows.Forms.Button()
        Me.lblPosition = New System.Windows.Forms.Label()
        Me.guiOff = New System.Windows.Forms.Button()
        Me.guiDestination = New System.Windows.Forms.TextBox()
        Me.lblDestination = New System.Windows.Forms.Label()
        Me.lblSpeed = New System.Windows.Forms.Label()
        Me.lblControl = New System.Windows.Forms.Label()
        Me.groupBox1 = New System.Windows.Forms.GroupBox()
        Me.lblSpeedUnit = New System.Windows.Forms.Label()
        Me.guiUp = New System.Windows.Forms.Button()
        Me.guiDown = New System.Windows.Forms.Button()
        Me.guiPos = New System.Windows.Forms.Button()
        Me.guiSpeed = New System.Windows.Forms.TextBox()
        Me.guiControl = New System.Windows.Forms.ComboBox()
        Me.lblTime = New System.Windows.Forms.Label()
        Me.guiTime = New System.Windows.Forms.TextBox()
        Me.groupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'guiHalt
        '
        Me.guiHalt.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.guiHalt.Location = New System.Drawing.Point(68, 63)
        Me.guiHalt.Name = "guiHalt"
        Me.guiHalt.Size = New System.Drawing.Size(43, 43)
        Me.guiHalt.TabIndex = 43
        Me.guiHalt.Text = "Halt"
        Me.guiHalt.UseVisualStyleBackColor = True
        '
        'guiExtension
        '
        Me.guiExtension.BackColor = System.Drawing.Color.Black
        Me.guiExtension.Font = New System.Drawing.Font("Microsoft Sans Serif", 14.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.guiExtension.ForeColor = System.Drawing.Color.Lime
        Me.guiExtension.Location = New System.Drawing.Point(461, 28)
        Me.guiExtension.Name = "guiExtension"
        Me.guiExtension.Size = New System.Drawing.Size(145, 29)
        Me.guiExtension.TabIndex = 64
        Me.guiExtension.Text = "0.000"
        Me.guiExtension.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'guiLoad
        '
        Me.guiLoad.BackColor = System.Drawing.Color.Black
        Me.guiLoad.Font = New System.Drawing.Font("Microsoft Sans Serif", 14.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.guiLoad.ForeColor = System.Drawing.Color.Lime
        Me.guiLoad.Location = New System.Drawing.Point(308, 28)
        Me.guiLoad.Name = "guiLoad"
        Me.guiLoad.Size = New System.Drawing.Size(145, 29)
        Me.guiLoad.TabIndex = 63
        Me.guiLoad.Text = "0.000"
        Me.guiLoad.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'guiPosition
        '
        Me.guiPosition.BackColor = System.Drawing.Color.Black
        Me.guiPosition.Font = New System.Drawing.Font("Microsoft Sans Serif", 14.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.guiPosition.ForeColor = System.Drawing.Color.Lime
        Me.guiPosition.Location = New System.Drawing.Point(157, 28)
        Me.guiPosition.Name = "guiPosition"
        Me.guiPosition.Size = New System.Drawing.Size(145, 29)
        Me.guiPosition.TabIndex = 62
        Me.guiPosition.Text = "0.000"
        Me.guiPosition.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'guiDebug
        '
        Me.guiDebug.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.guiDebug.HideSelection = False
        Me.guiDebug.Location = New System.Drawing.Point(6, 241)
        Me.guiDebug.Name = "guiDebug"
        Me.guiDebug.ReadOnly = True
        Me.guiDebug.Size = New System.Drawing.Size(598, 232)
        Me.guiDebug.TabIndex = 56
        Me.guiDebug.Text = "Starting Communication" & Global.Microsoft.VisualBasic.ChrW(10)
        Me.guiDebug.WordWrap = False
        '
        'lblExtension
        '
        Me.lblExtension.AutoSize = True
        Me.lblExtension.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblExtension.Location = New System.Drawing.Point(491, 9)
        Me.lblExtension.Name = "lblExtension"
        Me.lblExtension.Size = New System.Drawing.Size(92, 13)
        Me.lblExtension.TabIndex = 61
        Me.lblExtension.Text = "Extension [mm]"
        '
        'lblDestinationUnit
        '
        Me.lblDestinationUnit.AutoSize = True
        Me.lblDestinationUnit.Location = New System.Drawing.Point(428, 78)
        Me.lblDestinationUnit.Name = "lblDestinationUnit"
        Me.lblDestinationUnit.Size = New System.Drawing.Size(23, 13)
        Me.lblDestinationUnit.TabIndex = 54
        Me.lblDestinationUnit.Text = "mm"
        '
        'lblLoad
        '
        Me.lblLoad.AutoSize = True
        Me.lblLoad.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblLoad.Location = New System.Drawing.Point(356, 9)
        Me.lblLoad.Name = "lblLoad"
        Me.lblLoad.Size = New System.Drawing.Size(56, 13)
        Me.lblLoad.TabIndex = 60
        Me.lblLoad.Text = "Load [N]"
        '
        'guiOn
        '
        Me.guiOn.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.guiOn.Location = New System.Drawing.Point(16, 21)
        Me.guiOn.Name = "guiOn"
        Me.guiOn.Size = New System.Drawing.Size(43, 43)
        Me.guiOn.TabIndex = 21
        Me.guiOn.Text = "On"
        Me.guiOn.UseVisualStyleBackColor = True
        '
        'lblPosition
        '
        Me.lblPosition.AutoSize = True
        Me.lblPosition.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblPosition.Location = New System.Drawing.Point(195, 9)
        Me.lblPosition.Name = "lblPosition"
        Me.lblPosition.Size = New System.Drawing.Size(82, 13)
        Me.lblPosition.TabIndex = 59
        Me.lblPosition.Text = "Position [mm]"
        '
        'guiOff
        '
        Me.guiOff.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.guiOff.Location = New System.Drawing.Point(16, 63)
        Me.guiOff.Name = "guiOff"
        Me.guiOff.Size = New System.Drawing.Size(43, 43)
        Me.guiOff.TabIndex = 22
        Me.guiOff.Text = "Off"
        Me.guiOff.UseVisualStyleBackColor = True
        '
        'guiDestination
        '
        Me.guiDestination.Location = New System.Drawing.Point(318, 75)
        Me.guiDestination.Name = "guiDestination"
        Me.guiDestination.Size = New System.Drawing.Size(100, 20)
        Me.guiDestination.TabIndex = 51
        Me.guiDestination.Text = "0"
        Me.guiDestination.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'lblDestination
        '
        Me.lblDestination.AutoSize = True
        Me.lblDestination.Location = New System.Drawing.Point(251, 78)
        Me.lblDestination.Name = "lblDestination"
        Me.lblDestination.Size = New System.Drawing.Size(60, 13)
        Me.lblDestination.TabIndex = 50
        Me.lblDestination.Text = "Destination"
        '
        'lblSpeed
        '
        Me.lblSpeed.AutoSize = True
        Me.lblSpeed.Location = New System.Drawing.Point(251, 54)
        Me.lblSpeed.Name = "lblSpeed"
        Me.lblSpeed.Size = New System.Drawing.Size(38, 13)
        Me.lblSpeed.TabIndex = 49
        Me.lblSpeed.Text = "Speed"
        '
        'lblControl
        '
        Me.lblControl.AutoSize = True
        Me.lblControl.Location = New System.Drawing.Point(251, 27)
        Me.lblControl.Name = "lblControl"
        Me.lblControl.Size = New System.Drawing.Size(40, 13)
        Me.lblControl.TabIndex = 48
        Me.lblControl.Text = "Control"
        '
        'groupBox1
        '
        Me.groupBox1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.groupBox1.Controls.Add(Me.guiHalt)
        Me.groupBox1.Controls.Add(Me.lblDestinationUnit)
        Me.groupBox1.Controls.Add(Me.guiOn)
        Me.groupBox1.Controls.Add(Me.lblSpeedUnit)
        Me.groupBox1.Controls.Add(Me.guiOff)
        Me.groupBox1.Controls.Add(Me.guiDestination)
        Me.groupBox1.Controls.Add(Me.guiUp)
        Me.groupBox1.Controls.Add(Me.lblDestination)
        Me.groupBox1.Controls.Add(Me.guiDown)
        Me.groupBox1.Controls.Add(Me.lblSpeed)
        Me.groupBox1.Controls.Add(Me.guiPos)
        Me.groupBox1.Controls.Add(Me.lblControl)
        Me.groupBox1.Controls.Add(Me.guiSpeed)
        Me.groupBox1.Controls.Add(Me.guiControl)
        Me.groupBox1.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.groupBox1.Location = New System.Drawing.Point(6, 73)
        Me.groupBox1.Name = "groupBox1"
        Me.groupBox1.Size = New System.Drawing.Size(598, 162)
        Me.groupBox1.TabIndex = 65
        Me.groupBox1.TabStop = False
        '
        'lblSpeedUnit
        '
        Me.lblSpeedUnit.AutoSize = True
        Me.lblSpeedUnit.Location = New System.Drawing.Point(428, 54)
        Me.lblSpeedUnit.Name = "lblSpeedUnit"
        Me.lblSpeedUnit.Size = New System.Drawing.Size(33, 13)
        Me.lblSpeedUnit.TabIndex = 53
        Me.lblSpeedUnit.Text = "mm/s"
        '
        'guiUp
        '
        Me.guiUp.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.guiUp.Location = New System.Drawing.Point(68, 21)
        Me.guiUp.Name = "guiUp"
        Me.guiUp.Size = New System.Drawing.Size(43, 43)
        Me.guiUp.TabIndex = 42
        Me.guiUp.Text = "Up"
        Me.guiUp.UseVisualStyleBackColor = True
        '
        'guiDown
        '
        Me.guiDown.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.guiDown.Location = New System.Drawing.Point(68, 105)
        Me.guiDown.Name = "guiDown"
        Me.guiDown.Size = New System.Drawing.Size(43, 43)
        Me.guiDown.TabIndex = 44
        Me.guiDown.Text = "Down"
        Me.guiDown.UseVisualStyleBackColor = True
        '
        'guiPos
        '
        Me.guiPos.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.guiPos.Location = New System.Drawing.Point(167, 21)
        Me.guiPos.Name = "guiPos"
        Me.guiPos.Size = New System.Drawing.Size(43, 43)
        Me.guiPos.TabIndex = 45
        Me.guiPos.Text = "Pos"
        Me.guiPos.UseVisualStyleBackColor = True
        '
        'guiSpeed
        '
        Me.guiSpeed.Location = New System.Drawing.Point(319, 51)
        Me.guiSpeed.Name = "guiSpeed"
        Me.guiSpeed.Size = New System.Drawing.Size(99, 20)
        Me.guiSpeed.TabIndex = 46
        Me.guiSpeed.Text = "5"
        Me.guiSpeed.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'guiControl
        '
        Me.guiControl.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.guiControl.FormattingEnabled = True
        Me.guiControl.Items.AddRange(New Object() {"Position", "Load", "Extension"})
        Me.guiControl.Location = New System.Drawing.Point(319, 24)
        Me.guiControl.Name = "guiControl"
        Me.guiControl.Size = New System.Drawing.Size(99, 21)
        Me.guiControl.TabIndex = 47
        '
        'lblTime
        '
        Me.lblTime.AutoSize = True
        Me.lblTime.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblTime.Location = New System.Drawing.Point(54, 9)
        Me.lblTime.Name = "lblTime"
        Me.lblTime.Size = New System.Drawing.Size(52, 13)
        Me.lblTime.TabIndex = 58
        Me.lblTime.Text = "Time [s]"
        '
        'guiTime
        '
        Me.guiTime.BackColor = System.Drawing.Color.Black
        Me.guiTime.Font = New System.Drawing.Font("Microsoft Sans Serif", 14.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.guiTime.ForeColor = System.Drawing.Color.Lime
        Me.guiTime.Location = New System.Drawing.Point(6, 28)
        Me.guiTime.Name = "guiTime"
        Me.guiTime.Size = New System.Drawing.Size(145, 29)
        Me.guiTime.TabIndex = 57
        Me.guiTime.Text = "0.000"
        Me.guiTime.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'MainForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(610, 477)
        Me.Controls.Add(Me.guiExtension)
        Me.Controls.Add(Me.guiLoad)
        Me.Controls.Add(Me.guiPosition)
        Me.Controls.Add(Me.guiDebug)
        Me.Controls.Add(Me.lblExtension)
        Me.Controls.Add(Me.lblLoad)
        Me.Controls.Add(Me.lblPosition)
        Me.Controls.Add(Me.groupBox1)
        Me.Controls.Add(Me.lblTime)
        Me.Controls.Add(Me.guiTime)
        Me.Name = "MainForm"
        Me.Text = "DoPENet VB Demo"
        Me.groupBox1.ResumeLayout(False)
        Me.groupBox1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
  Private WithEvents guiHalt As System.Windows.Forms.Button
  Private WithEvents guiExtension As System.Windows.Forms.TextBox
  Private WithEvents guiLoad As System.Windows.Forms.TextBox
    Private WithEvents guiPosition As System.Windows.Forms.TextBox
    Private WithEvents guiDebug As System.Windows.Forms.RichTextBox
  Private WithEvents lblExtension As System.Windows.Forms.Label
  Private WithEvents lblDestinationUnit As System.Windows.Forms.Label
  Private WithEvents lblLoad As System.Windows.Forms.Label
  Private WithEvents guiOn As System.Windows.Forms.Button
  Private WithEvents lblPosition As System.Windows.Forms.Label
  Private WithEvents guiOff As System.Windows.Forms.Button
  Private WithEvents guiDestination As System.Windows.Forms.TextBox
  Private WithEvents lblDestination As System.Windows.Forms.Label
  Private WithEvents lblSpeed As System.Windows.Forms.Label
  Private WithEvents lblControl As System.Windows.Forms.Label
  Private WithEvents groupBox1 As System.Windows.Forms.GroupBox
  Private WithEvents lblSpeedUnit As System.Windows.Forms.Label
  Private WithEvents guiUp As System.Windows.Forms.Button
  Private WithEvents guiDown As System.Windows.Forms.Button
  Private WithEvents guiPos As System.Windows.Forms.Button
  Private WithEvents guiSpeed As System.Windows.Forms.TextBox
  Private WithEvents guiControl As System.Windows.Forms.ComboBox
  Private WithEvents lblTime As System.Windows.Forms.Label
  Private WithEvents guiTime As System.Windows.Forms.TextBox

End Class
