/*-----------------------------------------------------------------------------
 
 Project:     DoPENet - Demo
 Description: Demo project for DoPE .NET
 
 (C) DOLI Elektronik GmbH, 2010-present
 
 Author:   Benjamin Fröhlich / HEG
  
Changes :
=========
 
 EDR 01.02.2011 - V1.0
 * wrote it.
 
 HEG 15.02.2011 - V2.0
 * removed trace stuff to simplify customer demo
 
 HEG 19.09.2011 - V2.01
 * IoSHalt Message Handler implemented
 
 HEG 30.10.2013 - V2.77
 * OnDebugMsg event handler installed (but not enabled)
 
 HEG 27.10.2014 - V2.80
 * Simplified demo
 * OnDataBlock handler implemented
 
 HEG 02.03.2016 - V2.83
 * Rmc.Enable needs to be called after Setup.SelSetup
-------------------------------------------------------------------------------*/


// To use DoPE .NET in your own project, the following files must be in your .exe directory:
// - DoPE.dll
// - DoDpx.dll
// - DoPENet.dll
//
// In your project, you also need to add a reference for the files
// - DoPENet.dll
//
// How to add a reference?
// - In Solution Explorer, right-click on the project node and click Add Reference.
// - In the Add Reference dialog box, select the "Browse"-tab and choose the DoPENet.dll
// - Click the OK-Button.


// uncomment the folling line to enable OnData handler
//#define ONDATABLOCK


using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using Doli.DoPE;

namespace DoPENet_CSharpDemo
{
  /// <summary>
  /// Demo-application for the DoPE .NET library.
  /// </summary>
  public partial class MainForm : Form
  {
    #region Initialization

    /// <summary>
    /// Represents one EDC.
    /// This object is needed to perform DoPE tasks.
    /// (Similar to the DoPE-handle in C++.)
    /// </summary>
    private Edc MyEdc;

    /// <summary>
    /// TAN number assigned to a DoPE command.
    /// (To get informed when a task has been performed.)
    /// </summary>
    private short MyTan;

    /// <summary>
    /// Just an error constant string which is used
    /// when the EDC could not be initialized correctly.
    /// </summary>
    private const string CommandFailedString = "Command failed. Please make sure, that the Edc is successfully initialized. \n";


    ///----------------------------------------------------------------------
    /// <summary>Constructor</summary>
    ///----------------------------------------------------------------------
    public MainForm()
    {
      // Initialize graphical-user-interface.
      InitializeComponent();
    }

    ///----------------------------------------------------------------------
    /// <summary>FormShown initialzes GUI and starts communication with EDC</summary>
    ///----------------------------------------------------------------------
    private void MainForm_Shown(object sender, EventArgs e)
    {
      // show GUI
      Application.DoEvents();

      // show DoPE.Ctrl enum members in guiControl combo-box.
      guiControl.DataSource = Enum.GetNames(typeof(DoPE.CTRL));

      // Set the control-combobox to "position".
      guiControl.SelectedIndex = (int)DoPE.CTRL.POS;

      // Connect to EDC
      ConnectToEdc();
    }

    ///----------------------------------------------------------------------
    /// <summary>Connect to EDC</summary>
    ///----------------------------------------------------------------------
    private void ConnectToEdc()
    {
      // tell DoPE which DoPENet.dll and DoPE.dll version we are using
      // THE API CANNOT BE USED WITHOUT THIS CHECK !
      DoPE.CheckApi("2.91");

      Cursor.Current = Cursors.WaitCursor;

      try
      {
        DoPE.ERR error;

        // open the first EDC found on this PC
        MyEdc = new Edc(DoPE.OpenBy.DeviceId, 0);

        // hang in event-handler to receive DoPE-events
        MyEdc.Eh.OnLineHdlr += new DoPE.OnLineHdlr(OnLine);
#if ONDATABLOCK
        MyEdc.Eh.OnDataBlockHdlr += new DoPE.OnDataBlockHdlr(OnDataBlock);
        // Set number of samples for OnDataBlock events
        // (with 1 ms data refresh rate this leads to a
        //  display refresh every 300 ms)
        error = MyEdc.Eh.SetOnDataBlockSize(300);
        DisplayError(error, "SetOnDataBlockSize");
#else
        MyEdc.Eh.OnDataHdlr += new DoPE.OnDataHdlr(OnData);
#endif
        MyEdc.Eh.OnCommandErrorHdlr += new DoPE.OnCommandErrorHdlr(OnCommandError);
        MyEdc.Eh.OnPosMsgHdlr += new DoPE.OnPosMsgHdlr(OnPosMsg);
        MyEdc.Eh.OnTPosMsgHdlr += new DoPE.OnTPosMsgHdlr(OnTPosMsg);
        MyEdc.Eh.OnLPosMsgHdlr += new DoPE.OnLPosMsgHdlr(OnLPosMsg);
        MyEdc.Eh.OnSftMsgHdlr += new DoPE.OnSftMsgHdlr(OnSftMsg);
        MyEdc.Eh.OnOffsCMsgHdlr += new DoPE.OnOffsCMsgHdlr(OnOffsCMsg);
        MyEdc.Eh.OnCheckMsgHdlr += new DoPE.OnCheckMsgHdlr(OnCheckMsg);
        MyEdc.Eh.OnShieldMsgHdlr += new DoPE.OnShieldMsgHdlr(OnShieldMsg);
        MyEdc.Eh.OnRefSignalMsgHdlr += new DoPE.OnRefSignalMsgHdlr(OnRefSignalMsg);
        MyEdc.Eh.OnSensorMsgHdlr += new DoPE.OnSensorMsgHdlr(OnSensorMsg);
        MyEdc.Eh.OnIoSHaltMsgHdlr += new DoPE.OnIoSHaltMsgHdlr(OnIoSHaltMsg);
        MyEdc.Eh.OnKeyMsgHdlr += new DoPE.OnKeyMsgHdlr(OnKeyMsg);
        MyEdc.Eh.OnRuntimeErrorHdlr += new DoPE.OnRuntimeErrorHdlr(OnRuntimeError);
        MyEdc.Eh.OnOverflowHdlr += new DoPE.OnOverflowHdlr(OnOverflow);
        MyEdc.Eh.OnSystemMsgHdlr += new DoPE.OnSystemMsgHdlr(OnSystemMsg);
        MyEdc.Eh.OnDebugMsgHdlr += new DoPE.OnDebugMsgHdlr(OnDebugMsg);
        MyEdc.Eh.OnRmcEventHdlr += new DoPE.OnRmcEventHdlr(OnRmcEvent);

        // Set UserScale
        DoPE.UserScale userScale = new DoPE.UserScale();
        // set position and extension scale to mm
        userScale[DoPE.SENSOR.SENSOR_S] = 1000;
        userScale[DoPE.SENSOR.SENSOR_E] = 1000;

        // Select machine setup and initialize
        error = MyEdc.Setup.SelSetup(DoPE.SETUP_NUMBER.SETUP_1, userScale, ref MyTan, ref MyTan);
        if (error != DoPE.ERR.NOERROR)
          DisplayError(error, "SelectSetup");
        else
          Display("SelectSetup : OK !\n");

        MyEdc.Rmc.Enable(-1, -1);
      }
      catch (DoPEException ex)
      {
        // During the initialization and the
        // shut-down phase a DoPE Exception can arise.
        // Other errors are reported by the DoPE
        // error return codes.
        Display(string.Format("{0}\n", ex));
      }
        
      Cursor.Current = Cursors.Default;
    }

    #endregion

    #region GUI

    ///----------------------------------------------------------------------
    /// <summary>
    /// Formates and displays DoPE-errors.
    /// </summary>
    /// <param name="error">the dope error to display</param>
    /// <param name="Text">additional text to display</param>
    ///----------------------------------------------------------------------
    private void DisplayError(DoPE.ERR error, string Text)
    {
      if (error != DoPE.ERR.NOERROR)
        Display(Text + " Error: " + error + "\n");
    }

    ///----------------------------------------------------------------------
    /// <summary>Display debug text</summary>
    ///----------------------------------------------------------------------
    private void Display(string Text)
    {
      guiDebug.AppendText(Text);
      Refresh();
    }

    ///----------------------------------------------------------------------
    /// <summary>Activates the EDC's drive.</summary>
    ///----------------------------------------------------------------------
    private void guiOn_Click(object sender, EventArgs e)
    {
      try
      {
        DoPE.ERR error = MyEdc.Move.On();
        DisplayError(error, "On");
      }
      catch (NullReferenceException)
      {
        Display(CommandFailedString);
      }
   }

    ///----------------------------------------------------------------------
    /// <summary>Deactivates the EDC's drive.</summary>
    ///----------------------------------------------------------------------
    private void guiOff_Click(object sender, EventArgs e)
    {
      try
      {
        DoPE.ERR error = MyEdc.Move.Off();
        DisplayError(error, "Off");
      }
      catch (NullReferenceException)
      {
        Display(CommandFailedString);
      }
    }

    ///----------------------------------------------------------------------
    /// <summary>Sends a move-command with direction "up" to the EDC.</summary>
    ///----------------------------------------------------------------------
    private void guiUp_Click(object sender, EventArgs e)
    {
      try
      {
        DoPE.ERR error = MyEdc.Move.FDPoti(DoPE.CTRL.POS, 0, DoPE.SENSOR.SENSOR_DP, 3, DoPE.EXT.SPEED_UP, 2, ref MyTan);
        DisplayError(error, "FDPoti");
      }
      catch (NullReferenceException)
      {
        Display(CommandFailedString);
      }
    }

    ///----------------------------------------------------------------------
    /// <summary>Sends a halt-command to the EDC.</summary>
    ///----------------------------------------------------------------------
    private void guiHalt_Click(object sender, EventArgs e)
    {
      try
      {
        DoPE.ERR error = MyEdc.Move.Halt(DoPE.CTRL.POS, ref MyTan);
        DisplayError(error, "Halt");
      }
      catch (NullReferenceException)
      {
        Display(CommandFailedString);
      }
    }

    ///----------------------------------------------------------------------
    /// <summary>Sends a move-command with direction "down" to the EDC.</summary>
    ///----------------------------------------------------------------------
    private void guiDown_Click(object sender, EventArgs e)
    {
      try
      {
        DoPE.ERR error = MyEdc.Move.FDPoti(DoPE.CTRL.POS, 0, DoPE.SENSOR.SENSOR_DP, 3, DoPE.EXT.SPEED_DOWN, 2, ref MyTan);
        DisplayError(error, "FDPoti");
      }
      catch (NullReferenceException)
      {
        Display(CommandFailedString);
      }
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// Sends a move command to the EDC. The command-parameters
    /// are copied from the user-interface.
    /// </summary>
    ///----------------------------------------------------------------------
    private void guiPos_Click(object sender, EventArgs e)
    {
      DoPE.CTRL control;
      double speed;
      double destination;

      try
      {
        control = (DoPE.CTRL)guiControl.SelectedIndex;
        speed = Convert.ToDouble(guiSpeed.Text);
        destination = Convert.ToDouble(guiDestination.Text);

        DoPE.ERR error = MyEdc.Move.Pos(control, speed, destination, ref MyTan);
        DisplayError(error, "Pos");
     }
      catch (NullReferenceException)
      {
        Display(CommandFailedString);
      }
    }

    ///----------------------------------------------------------------------
    /// <summary>Sets the correct units depending on the selected control-mode.</summary>
    ///----------------------------------------------------------------------
    private void guiControl_SelectedIndexChanged(object sender, EventArgs e)
    {
      DoPE.CTRL control = (DoPE.CTRL)guiControl.SelectedIndex;

      switch (control)
      {
        case DoPE.CTRL.POS:
          lblSpeedUnit.Text = "mm/s";
          lblDestinationUnit.Text = "mm";
          break;
        case DoPE.CTRL.LOAD:
          lblSpeedUnit.Text = "N/s";
          lblDestinationUnit.Text = "N";
          break;
        case DoPE.CTRL.EXTENSION:
          lblSpeedUnit.Text = "mm/s";
          lblDestinationUnit.Text = "mm";
          break;
        default:
          lblSpeedUnit.Text = "Unit/s";
          lblDestinationUnit.Text = "Unit";
          break;
      }
    }

    #endregion

    #region DoPE Events

    private int OnLine(DoPE.LineState LineState, object Parameter)
    {
      Display(string.Format("OnLine: {0}\n", LineState));

      return 0;
    }

#if ONDATABLOCK
    private int OnDataBlock(ref DoPE.OnDataBlock Block, object Parameter)
    {
      if (Block.Data.Length > 0)
      {
        // refesh edit controls with the latest sample
        DoPE.Data Sample = Block.Data[Block.Data.Length - 1].Data;
        string text;

        text = String.Format("{0}", Sample.Time.ToString("0.000"));
        guiTime.Text = text;
        text = String.Format("{0}", Sample.Sensor[(int)DoPE.SENSOR.SENSOR_S].ToString("0.000"));
        guiPosition.Text = text;
        text = String.Format("{0}", Sample.Sensor[(int)DoPE.SENSOR.SENSOR_F].ToString("0.000"));
        guiLoad.Text = text;
        text = String.Format("{0}", Sample.Sensor[(int)DoPE.SENSOR.SENSOR_E].ToString("0.000"));
        guiExtension.Text = text;
      }
      return 0;
    }
#else
    private Int32 LastTime = Environment.TickCount;
    private int OnData(ref DoPE.OnData Data, object Parameter)
    {
      if (Data.DoPError == DoPE.ERR.NOERROR)
      {
        DoPE.Data Sample = Data.Data;
        Int32 Time = Environment.TickCount;
        if ((Time - LastTime) >= 300 /*ms*/)
        {
          LastTime = Time;
          string text;
          text = String.Format("{0}", Sample.Time.ToString("0.000"));
          guiTime.Text = text;
          text = String.Format("{0}", Sample.Sensor[(int)DoPE.SENSOR.SENSOR_S].ToString("0.000"));
          guiPosition.Text = text;
          text = String.Format("{0}", Sample.Sensor[(int)DoPE.SENSOR.SENSOR_F].ToString("0.000"));
          guiLoad.Text = text;
          text = String.Format("{0}", Sample.Sensor[(int)DoPE.SENSOR.SENSOR_E].ToString("0.000"));
          guiExtension.Text = text;
        }
      }
      return 0;
    }
#endif

    private int OnCommandError(ref DoPE.OnCommandError CommandError, object Parameter)
    {
      Display(string.Format("OnCommandError: CommandNumber={0} ErrorNumber={1} usTAN={2} \n",
        CommandError.CommandNumber, CommandError.ErrorNumber, CommandError.usTAN));

      return 0;
    }

    private int OnPosMsg(ref DoPE.OnPosMsg PosMsg, object Parameter)
    {
      Display(string.Format("OnPosMsg: DoPError={0} Reached={1} Time={2} Control={3} Position={4} DControl={5} Destination={6} usTAN={7} \n",
        PosMsg.DoPError, PosMsg.Reached, PosMsg.Time, PosMsg.Control, PosMsg.Position, PosMsg.DControl, PosMsg.Destination, PosMsg.usTAN));

      return 0;
    }

    private int OnTPosMsg(ref DoPE.OnPosMsg PosMsg, object Parameter)
    {
      Display(string.Format("OnTPosMsg: DoPError={0} Reached={1} Time={2} Control={3} Position={4} DControl={5} Destination={6} usTAN={7} \n",
        PosMsg.DoPError, PosMsg.Reached, PosMsg.Time, PosMsg.Control, PosMsg.Position, PosMsg.DControl, PosMsg.Destination, PosMsg.usTAN));

      return 0;
    }

    private int OnLPosMsg(ref DoPE.OnPosMsg PosMsg, object Parameter)
    {
      Display(string.Format("OnLPosMsg: DoPError={0} Reached={1} Time={2} Control={3} Position={4} DControl={5} Destination={6} usTAN={7} \n",
        PosMsg.DoPError, PosMsg.Reached, PosMsg.Time, PosMsg.Control, PosMsg.Position, PosMsg.DControl, PosMsg.Destination, PosMsg.usTAN));

      return 0;
    }

    private int OnSftMsg(ref DoPE.OnSftMsg SftMsg, object Parameter)
    {
      Display(string.Format("OnSftMsg: DoPError={0} Upper={1} Time={2} Control={3} Position={4} usTAN={5} \n",
        SftMsg.DoPError, SftMsg.Upper, SftMsg.Time, SftMsg.Control, SftMsg.Position, SftMsg.usTAN));

      return 0;
    }

    private int OnOffsCMsg(ref DoPE.OnOffsCMsg OffsCMsg, object Parameter)
    {
      Display(string.Format("OnOffsCMsg: DoPError={0} Time={1} Offset={2} usTAN={3} \n",
        OffsCMsg.DoPError, OffsCMsg.Time, OffsCMsg.Offset, OffsCMsg.usTAN));

      return 0;
    }

    private int OnCheckMsg(ref DoPE.OnCheckMsg CheckMsg, object Parameter)
    {
      Display(string.Format("OnCheckMsg: DoPError={0} Action={1} Time={2} CheckId={3} Position={4} SensorNo={5} usTAN={6} \n",
        CheckMsg.DoPError, CheckMsg.Action, CheckMsg.Time, CheckMsg.CheckId, CheckMsg.Position, CheckMsg.SensorNo, CheckMsg.usTAN));

      return 0;
    }

    private int OnShieldMsg(ref DoPE.OnShieldMsg ShieldMsg, object Parameter)
    {
      Display(string.Format("OnShieldMsg: DoPError={0} Action={1} Time={2} SensorNo={3} Position={4} usTAN={5} \n",
        ShieldMsg.DoPError, ShieldMsg.Action, ShieldMsg.Time, ShieldMsg.SensorNo, ShieldMsg.Position, ShieldMsg.usTAN));

      return 0;
    }

    private int OnRefSignalMsg(ref DoPE.OnRefSignalMsg RefSignalMsg, object Parameter)
    {
      Display(string.Format("OnRefSignalMsg: DoPError={0} Time={1} SensorNo={2} Position={3} usTAN={4} \n",
        RefSignalMsg.DoPError, RefSignalMsg.Time, RefSignalMsg.SensorNo, RefSignalMsg.Position, RefSignalMsg.usTAN));

      return 0;
    }

    private int OnSensorMsg(ref DoPE.OnSensorMsg SensorMsg, object Parameter)
    {
      Display(string.Format("OnSensorMsg: DoPError={0} Time={1} SensorNo={2} usTAN={3} \n",
        SensorMsg.DoPError, SensorMsg.Time, SensorMsg.SensorNo, SensorMsg.usTAN));

      return 0;
    }

    private int OnIoSHaltMsg(ref DoPE.OnIoSHaltMsg IoSHaltMsg, object Parameter)
    {
      Display(string.Format("OnIoSHaltMsg: DoPError={0} Upper={1} Time={2} Control={3} Position={4} usTAN={5} \n",
        IoSHaltMsg.DoPError, IoSHaltMsg.Upper, IoSHaltMsg.Time, IoSHaltMsg.Control, IoSHaltMsg.Position, IoSHaltMsg.usTAN));

      return 0;
    }

    private int OnKeyMsg(ref DoPE.OnKeyMsg KeyMsg, object Parameter)
    {
      Display(string.Format("OnKeyMsg: DoPError={0} Time={1} Keys={2} NewKeys={3} GoneKeys={4} OemKeys={5} NewOemKeys={6} GoneOemKeys={7} usTAN={8} \n",
        KeyMsg.DoPError, KeyMsg.Time, KeyMsg.Keys, KeyMsg.NewKeys, KeyMsg.GoneKeys, KeyMsg.OemKeys, KeyMsg.NewOemKeys, KeyMsg.GoneOemKeys, KeyMsg.usTAN));

      return 0;
    }

    private int OnRuntimeError(ref DoPE.OnRuntimeError RuntimeError, object Parameter)
    {
      Display(string.Format("OnRuntimeError: DoPError={0} ErrorNumber={1} Time={2} Device={3} Bits={4} usTAN={5} \n",
        RuntimeError.DoPError, RuntimeError.ErrorNumber, RuntimeError.Time, RuntimeError.Device, RuntimeError.Bits, RuntimeError.usTAN));

      return 0;
    }

    private int OnOverflow(int Overflow, object Parameter)
    {
      Display(string.Format("OnOverflow: Overflow={0} \n", Overflow));

      return 0;
    }

    private int OnDebugMsg(ref DoPE.OnDebugMsg DebugMsg, object Parameter)
    {
      Display(string.Format("OnDebugMsg: DoPError={0} MsgType={1} Time={2} Text={3} \n",
        DebugMsg.DoPError, DebugMsg.MsgType, DebugMsg.Time, DebugMsg.Text));

      return 0;
    }

    private int OnSystemMsg(ref DoPE.OnSystemMsg SystemMsg, object Parameter)
    {
      Display(string.Format("OnSystemMsg: DoPError={0} MsgNumber={1} Time={2} Text={3} \n",
        SystemMsg.DoPError, SystemMsg.MsgNumber, SystemMsg.Time, SystemMsg.Text));

      return 0;
    }

    private int OnRmcEvent(ref DoPE.OnRmcEvent RmcEvent, object Parameter)
    {
      Display(string.Format("OnRmcEvent: Keys={0} NewKeys={1} GoneKeys={2} Leds={3} NewLeds={4} GoneLeds={5} \n",
        RmcEvent.Keys, RmcEvent.NewKeys, RmcEvent.GoneKeys, RmcEvent.Leds, RmcEvent.NewLeds, RmcEvent.GoneLeds));

      return 0;
    }

    #endregion
  }
}
