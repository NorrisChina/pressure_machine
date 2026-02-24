namespace DoPENet_CSharpDemo
{
  partial class MainForm
  {
    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
      if (disposing && (components != null))
      {
        components.Dispose();
      }
      base.Dispose(disposing);
    }

    #region Windows Form Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
      this.components = new System.ComponentModel.Container();
      this.guiDebug = new System.Windows.Forms.RichTextBox();
      this.lblExtension = new System.Windows.Forms.Label();
      this.lblLoad = new System.Windows.Forms.Label();
      this.lblPosition = new System.Windows.Forms.Label();
      this.lblTime = new System.Windows.Forms.Label();
      this.guiTime = new System.Windows.Forms.TextBox();
      this.guiOff = new System.Windows.Forms.Button();
      this.guiOn = new System.Windows.Forms.Button();
      this.guiPosition = new System.Windows.Forms.TextBox();
      this.guiLoad = new System.Windows.Forms.TextBox();
      this.guiExtension = new System.Windows.Forms.TextBox();
      this.guiHalt = new System.Windows.Forms.Button();
      this.guiUp = new System.Windows.Forms.Button();
      this.guiDown = new System.Windows.Forms.Button();
      this.guiPos = new System.Windows.Forms.Button();
      this.guiSpeed = new System.Windows.Forms.TextBox();
      this.guiControl = new System.Windows.Forms.ComboBox();
      this.lblControl = new System.Windows.Forms.Label();
      this.lblSpeed = new System.Windows.Forms.Label();
      this.lblDestination = new System.Windows.Forms.Label();
      this.guiDestination = new System.Windows.Forms.TextBox();
      this.lblSpeedUnit = new System.Windows.Forms.Label();
      this.lblDestinationUnit = new System.Windows.Forms.Label();
      this.StartCommunicationWithEdcTimer = new System.Windows.Forms.Timer(this.components);
      this.groupBox1 = new System.Windows.Forms.GroupBox();
      this.groupBox1.SuspendLayout();
      this.SuspendLayout();
      // 
      // guiDebug
      // 
      this.guiDebug.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
      this.guiDebug.HideSelection = false;
      this.guiDebug.Location = new System.Drawing.Point(12, 239);
      this.guiDebug.Name = "guiDebug";
      this.guiDebug.ReadOnly = true;
      this.guiDebug.Size = new System.Drawing.Size(600, 208);
      this.guiDebug.TabIndex = 0;
      this.guiDebug.Text = "Starting Communication\n";
      // 
      // lblExtension
      // 
      this.lblExtension.AutoSize = true;
      this.lblExtension.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.lblExtension.Location = new System.Drawing.Point(497, 7);
      this.lblExtension.Name = "lblExtension";
      this.lblExtension.Size = new System.Drawing.Size(92, 13);
      this.lblExtension.TabIndex = 32;
      this.lblExtension.Text = "Extension [mm]";
      // 
      // lblLoad
      // 
      this.lblLoad.AutoSize = true;
      this.lblLoad.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.lblLoad.Location = new System.Drawing.Point(362, 7);
      this.lblLoad.Name = "lblLoad";
      this.lblLoad.Size = new System.Drawing.Size(56, 13);
      this.lblLoad.TabIndex = 30;
      this.lblLoad.Text = "Load [N]";
      // 
      // lblPosition
      // 
      this.lblPosition.AutoSize = true;
      this.lblPosition.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.lblPosition.Location = new System.Drawing.Point(201, 7);
      this.lblPosition.Name = "lblPosition";
      this.lblPosition.Size = new System.Drawing.Size(82, 13);
      this.lblPosition.TabIndex = 28;
      this.lblPosition.Text = "Position [mm]";
      // 
      // lblTime
      // 
      this.lblTime.AutoSize = true;
      this.lblTime.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.lblTime.Location = new System.Drawing.Point(60, 7);
      this.lblTime.Name = "lblTime";
      this.lblTime.Size = new System.Drawing.Size(52, 13);
      this.lblTime.TabIndex = 26;
      this.lblTime.Text = "Time [s]";
      // 
      // guiTime
      // 
      this.guiTime.BackColor = System.Drawing.Color.Black;
      this.guiTime.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.guiTime.ForeColor = System.Drawing.Color.Lime;
      this.guiTime.Location = new System.Drawing.Point(12, 26);
      this.guiTime.Name = "guiTime";
      this.guiTime.Size = new System.Drawing.Size(145, 29);
      this.guiTime.TabIndex = 25;
      this.guiTime.Text = "0.000";
      this.guiTime.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
      // 
      // guiOff
      // 
      this.guiOff.Font = new System.Drawing.Font("Microsoft Sans Serif", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.guiOff.Location = new System.Drawing.Point(16, 63);
      this.guiOff.Name = "guiOff";
      this.guiOff.Size = new System.Drawing.Size(43, 43);
      this.guiOff.TabIndex = 22;
      this.guiOff.Text = "Off";
      this.guiOff.UseVisualStyleBackColor = true;
      this.guiOff.Click += new System.EventHandler(this.guiOff_Click);
      // 
      // guiOn
      // 
      this.guiOn.Font = new System.Drawing.Font("Microsoft Sans Serif", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.guiOn.Location = new System.Drawing.Point(16, 21);
      this.guiOn.Name = "guiOn";
      this.guiOn.Size = new System.Drawing.Size(43, 43);
      this.guiOn.TabIndex = 21;
      this.guiOn.Text = "On";
      this.guiOn.UseVisualStyleBackColor = true;
      this.guiOn.Click += new System.EventHandler(this.guiOn_Click);
      // 
      // guiPosition
      // 
      this.guiPosition.BackColor = System.Drawing.Color.Black;
      this.guiPosition.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.guiPosition.ForeColor = System.Drawing.Color.Lime;
      this.guiPosition.Location = new System.Drawing.Point(163, 26);
      this.guiPosition.Name = "guiPosition";
      this.guiPosition.Size = new System.Drawing.Size(145, 29);
      this.guiPosition.TabIndex = 39;
      this.guiPosition.Text = "0.000";
      this.guiPosition.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
      // 
      // guiLoad
      // 
      this.guiLoad.BackColor = System.Drawing.Color.Black;
      this.guiLoad.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.guiLoad.ForeColor = System.Drawing.Color.Lime;
      this.guiLoad.Location = new System.Drawing.Point(314, 26);
      this.guiLoad.Name = "guiLoad";
      this.guiLoad.Size = new System.Drawing.Size(145, 29);
      this.guiLoad.TabIndex = 40;
      this.guiLoad.Text = "0.000";
      this.guiLoad.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
      // 
      // guiExtension
      // 
      this.guiExtension.BackColor = System.Drawing.Color.Black;
      this.guiExtension.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.guiExtension.ForeColor = System.Drawing.Color.Lime;
      this.guiExtension.Location = new System.Drawing.Point(467, 26);
      this.guiExtension.Name = "guiExtension";
      this.guiExtension.Size = new System.Drawing.Size(145, 29);
      this.guiExtension.TabIndex = 41;
      this.guiExtension.Text = "0.000";
      this.guiExtension.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
      // 
      // guiHalt
      // 
      this.guiHalt.Font = new System.Drawing.Font("Microsoft Sans Serif", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.guiHalt.Location = new System.Drawing.Point(68, 63);
      this.guiHalt.Name = "guiHalt";
      this.guiHalt.Size = new System.Drawing.Size(43, 43);
      this.guiHalt.TabIndex = 43;
      this.guiHalt.Text = "Halt";
      this.guiHalt.UseVisualStyleBackColor = true;
      this.guiHalt.Click += new System.EventHandler(this.guiHalt_Click);
      // 
      // guiUp
      // 
      this.guiUp.Font = new System.Drawing.Font("Microsoft Sans Serif", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.guiUp.Location = new System.Drawing.Point(68, 21);
      this.guiUp.Name = "guiUp";
      this.guiUp.Size = new System.Drawing.Size(43, 43);
      this.guiUp.TabIndex = 42;
      this.guiUp.Text = "Up";
      this.guiUp.UseVisualStyleBackColor = true;
      this.guiUp.Click += new System.EventHandler(this.guiUp_Click);
      // 
      // guiDown
      // 
      this.guiDown.Font = new System.Drawing.Font("Microsoft Sans Serif", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.guiDown.Location = new System.Drawing.Point(68, 105);
      this.guiDown.Name = "guiDown";
      this.guiDown.Size = new System.Drawing.Size(43, 43);
      this.guiDown.TabIndex = 44;
      this.guiDown.Text = "Down";
      this.guiDown.UseVisualStyleBackColor = true;
      this.guiDown.Click += new System.EventHandler(this.guiDown_Click);
      // 
      // guiPos
      // 
      this.guiPos.Font = new System.Drawing.Font("Microsoft Sans Serif", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.guiPos.Location = new System.Drawing.Point(167, 21);
      this.guiPos.Name = "guiPos";
      this.guiPos.Size = new System.Drawing.Size(43, 43);
      this.guiPos.TabIndex = 45;
      this.guiPos.Text = "Pos";
      this.guiPos.UseVisualStyleBackColor = true;
      this.guiPos.Click += new System.EventHandler(this.guiPos_Click);
      // 
      // guiSpeed
      // 
      this.guiSpeed.Location = new System.Drawing.Point(319, 51);
      this.guiSpeed.Name = "guiSpeed";
      this.guiSpeed.Size = new System.Drawing.Size(99, 20);
      this.guiSpeed.TabIndex = 46;
      this.guiSpeed.Text = "5";
      this.guiSpeed.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
      // 
      // guiControl
      // 
      this.guiControl.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
      this.guiControl.FormattingEnabled = true;
      this.guiControl.Items.AddRange(new object[] {
            "Position",
            "Load",
            "Extension"});
      this.guiControl.Location = new System.Drawing.Point(319, 24);
      this.guiControl.MaxDropDownItems = 16;
      this.guiControl.Name = "guiControl";
      this.guiControl.Size = new System.Drawing.Size(99, 21);
      this.guiControl.TabIndex = 47;
      this.guiControl.SelectedIndexChanged += new System.EventHandler(this.guiControl_SelectedIndexChanged);
      // 
      // lblControl
      // 
      this.lblControl.AutoSize = true;
      this.lblControl.Location = new System.Drawing.Point(251, 27);
      this.lblControl.Name = "lblControl";
      this.lblControl.Size = new System.Drawing.Size(40, 13);
      this.lblControl.TabIndex = 48;
      this.lblControl.Text = "Control";
      // 
      // lblSpeed
      // 
      this.lblSpeed.AutoSize = true;
      this.lblSpeed.Location = new System.Drawing.Point(251, 54);
      this.lblSpeed.Name = "lblSpeed";
      this.lblSpeed.Size = new System.Drawing.Size(38, 13);
      this.lblSpeed.TabIndex = 49;
      this.lblSpeed.Text = "Speed";
      // 
      // lblDestination
      // 
      this.lblDestination.AutoSize = true;
      this.lblDestination.Location = new System.Drawing.Point(251, 78);
      this.lblDestination.Name = "lblDestination";
      this.lblDestination.Size = new System.Drawing.Size(60, 13);
      this.lblDestination.TabIndex = 50;
      this.lblDestination.Text = "Destination";
      // 
      // guiDestination
      // 
      this.guiDestination.Location = new System.Drawing.Point(318, 75);
      this.guiDestination.Name = "guiDestination";
      this.guiDestination.Size = new System.Drawing.Size(100, 20);
      this.guiDestination.TabIndex = 51;
      this.guiDestination.Text = "0";
      this.guiDestination.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
      // 
      // lblSpeedUnit
      // 
      this.lblSpeedUnit.AutoSize = true;
      this.lblSpeedUnit.Location = new System.Drawing.Point(428, 54);
      this.lblSpeedUnit.Name = "lblSpeedUnit";
      this.lblSpeedUnit.Size = new System.Drawing.Size(33, 13);
      this.lblSpeedUnit.TabIndex = 53;
      this.lblSpeedUnit.Text = "mm/s";
      // 
      // lblDestinationUnit
      // 
      this.lblDestinationUnit.AutoSize = true;
      this.lblDestinationUnit.Location = new System.Drawing.Point(428, 78);
      this.lblDestinationUnit.Name = "lblDestinationUnit";
      this.lblDestinationUnit.Size = new System.Drawing.Size(23, 13);
      this.lblDestinationUnit.TabIndex = 54;
      this.lblDestinationUnit.Text = "mm";
      // 
      // groupBox1
      // 
      this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
      this.groupBox1.Controls.Add(this.guiHalt);
      this.groupBox1.Controls.Add(this.lblDestinationUnit);
      this.groupBox1.Controls.Add(this.guiOn);
      this.groupBox1.Controls.Add(this.lblSpeedUnit);
      this.groupBox1.Controls.Add(this.guiOff);
      this.groupBox1.Controls.Add(this.guiDestination);
      this.groupBox1.Controls.Add(this.guiUp);
      this.groupBox1.Controls.Add(this.lblDestination);
      this.groupBox1.Controls.Add(this.guiDown);
      this.groupBox1.Controls.Add(this.lblSpeed);
      this.groupBox1.Controls.Add(this.guiPos);
      this.groupBox1.Controls.Add(this.lblControl);
      this.groupBox1.Controls.Add(this.guiSpeed);
      this.groupBox1.Controls.Add(this.guiControl);
      this.groupBox1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
      this.groupBox1.Location = new System.Drawing.Point(12, 71);
      this.groupBox1.Name = "groupBox1";
      this.groupBox1.Size = new System.Drawing.Size(600, 162);
      this.groupBox1.TabIndex = 55;
      this.groupBox1.TabStop = false;
      // 
      // MainForm
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(624, 457);
      this.Controls.Add(this.groupBox1);
      this.Controls.Add(this.guiExtension);
      this.Controls.Add(this.guiLoad);
      this.Controls.Add(this.guiPosition);
      this.Controls.Add(this.lblExtension);
      this.Controls.Add(this.lblLoad);
      this.Controls.Add(this.lblPosition);
      this.Controls.Add(this.lblTime);
      this.Controls.Add(this.guiTime);
      this.Controls.Add(this.guiDebug);
      this.Name = "MainForm";
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
      this.Text = "DoPENet C# Demo";
      this.Shown += new System.EventHandler(this.MainForm_Shown);
      this.groupBox1.ResumeLayout(false);
      this.groupBox1.PerformLayout();
      this.ResumeLayout(false);
      this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.RichTextBox guiDebug;
    private System.Windows.Forms.Label lblExtension;
    private System.Windows.Forms.Label lblLoad;
    private System.Windows.Forms.Label lblPosition;
    private System.Windows.Forms.Label lblTime;
    private System.Windows.Forms.TextBox guiTime;
    private System.Windows.Forms.Button guiOff;
    private System.Windows.Forms.Button guiOn;
    private System.Windows.Forms.TextBox guiPosition;
    private System.Windows.Forms.TextBox guiLoad;
    private System.Windows.Forms.TextBox guiExtension;
    private System.Windows.Forms.Button guiHalt;
    private System.Windows.Forms.Button guiUp;
    private System.Windows.Forms.Button guiDown;
    private System.Windows.Forms.Button guiPos;
    private System.Windows.Forms.TextBox guiSpeed;
    private System.Windows.Forms.ComboBox guiControl;
    private System.Windows.Forms.Label lblControl;
    private System.Windows.Forms.Label lblSpeed;
    private System.Windows.Forms.Label lblDestination;
    private System.Windows.Forms.TextBox guiDestination;
    private System.Windows.Forms.Label lblSpeedUnit;
    private System.Windows.Forms.Label lblDestinationUnit;
    private System.Windows.Forms.Timer StartCommunicationWithEdcTimer;
    private System.Windows.Forms.GroupBox groupBox1;
  }
}

