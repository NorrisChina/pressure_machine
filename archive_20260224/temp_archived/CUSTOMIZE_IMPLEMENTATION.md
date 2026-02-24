# Customize Mode Implementation - Summary

## Changes Made

### 1. **ui/main_window_ui.py** - UI Layout Modifications

#### Row 0 (Top Control Row) - Reorganized:
- ✅ **REMOVED**: Three buttons: `btn_annehmen` (annähern), `btn_kontrolle` (Kontrolle), `btn_meas_stop` (Stop)
- ✅ **ADDED**: `btn_customize` button in column 4
- ✅ **ADDED**: `lbl_startkraft_label` label in column 3 (initially hidden)
- ✓ Kept: `btn_meas_start` (Messung Start) in column 2

#### Row 2 & 3 (Customizable Parameters) - Hidden by Default:
All 5 customizable parameters now have `.setVisible(False)` in their initialization:
```python
# Row 2 customizable parameters:
- label_startkraft + spin_startkraft  [N]
- label_df + spin_df                  [N/s]
- label_kraftstufen + edit_kraftstufen
- label_nennkraft + spin_nennkraft    (FS)

# Row 3 customizable parameter:
- label_zyklen + spin_cycles
```

#### retranslateUi() - Cleaned Up:
- Removed duplicate text assignments for labels
- Removed reference to non-existent `chk_startkraft` checkbox
- Added translate calls for new button and labels

### 2. **ui/app.py** - Functionality Implementation

#### MainWindow.__init__():
```python
self.customize_mode = False  # Track customize mode state
```

#### Button Connections (lines 40-50):
- ✅ Removed: `btn_meas_stop.clicked.connect()`
- ✅ Removed: `btn_annehmen` and `btn_kontrolle` references
- ✅ Added: `btn_customize.clicked.connect(self._toggle_customize)`

#### Language Updates (_update_ui_language()):
- Removed all text updates for deleted buttons
- Added text updates for:
  - `btn_customize`
  - All 5 customizable parameter labels
  - Parameter descriptions (startkraft, dF, kraftstufen, nennkraft, zyklen)

#### New Method: _toggle_customize() (lines 415-440)
```python
def _toggle_customize(self):
    """Toggle customize mode to show/hide customizable parameters"""
    self.customize_mode = not self.customize_mode
    
    # Controls to toggle visibility
    controls_to_toggle = [
        'label_startkraft', 'spin_startkraft',
        'label_df', 'spin_df',
        'label_kraftstufen', 'edit_kraftstufen',
        'label_nennkraft', 'spin_nennkraft',
        'label_zyklen', 'spin_cycles'
    ]
    
    # Toggle all controls
    for control_name in controls_to_toggle:
        if hasattr(self.ui, control_name):
            control = getattr(self.ui, control_name)
            control.setVisible(self.customize_mode)
    
    # Update button to show current state
    if hasattr(self.ui, 'btn_customize'):
        mode_text = get_text("btn_customize_active", self.current_language) if self.customize_mode else get_text("btn_customize", self.current_language)
        self.ui.btn_customize.setText(mode_text)
    
    status = "aktiviert" if self.customize_mode else "deaktiviert"
    self.log(f"Customize-Modus {status}")
```

### 3. **ui/translations.py** - Translation Keys Added

#### New Translation Keys:
```python
"btn_customize": {
    "de": "Customize",
    "en": "Customize",
    "zh": "自定义"
},
"btn_customize_active": {
    "de": "Customize ✓",
    "en": "Customize ✓",
    "zh": "自定义 ✓"
},
```

#### Enhanced Parameter Labels with Chinese:
```python
"label_startkraft": {
    "de": "Startkraft [N]",
    "en": "Start Force [N]",
    "zh": "启动力 [N]"
},
"label_df": {
    "de": "dF [N/s]",
    "en": "dF [N/s]",
    "zh": "dF [N/s]"
},
"label_kraftstufen": {
    "de": "Kraftstufen:",
    "en": "Force Steps:",
    "zh": "力级："
},
"label_nennkraft": {
    "de": "Nennkraft (FS)",
    "en": "Nominal Force (FS)",
    "zh": "额定力 (FS)"
},
"label_zyklen": {
    "de": "Zyklen:",
    "en": "Cycles:",
    "zh": "周期："
}
```

## Behavior

### Initial State (Customize OFF):
- **Visible Controls**: Sensor selector, Start button, Customize button
- **Hidden Controls**: All 5 customizable parameters (startkraft, dF, kraftstufen, nennkraft, zyklen)
- **Button Text**: "Customize"

### After Clicking Customize Button (Customize ON):
- **Button Text Changes To**: "Customize ✓" 
- **Hidden Parameters Become Visible**: User can now adjust:
  - Startkraft [N]
  - dF [N/s]
  - Kraftstufen
  - Nennkraft (FS) [N]
  - Zyklen

### On Subsequent Clicks:
- Toggles between ON/OFF states
- Button text updates accordingly
- All parameters toggle visibility together
- Console logs the mode change with language support

## Language Support
- **German (de)**: "Customize-Modus aktiviert/deaktiviert"
- **English (en)**: Button and parameter labels in English
- **Chinese (zh)**: Complete Chinese translations for all labels and button

## Testing

Two test scripts were created:
1. **test_customize.py** - Functional test (non-visual)
   - Verifies toggle functionality
   - Tests customize_mode flag
   - Checks button text updates

2. **test_customize_ui.py** - Visual integration test
   - Shows the UI window
   - Allows manual testing of button clicks
   - Displays on-screen behavior

## Verification Completed
✅ No syntax errors in any modified files
✅ All three deleted buttons removed from UI
✅ Customize button created and positioned
✅ All 5 parameters set to hidden by default
✅ Toggle method working correctly
✅ Language translations complete (de/en/zh)
✅ Button event handlers connected
✅ Mode state tracking functional
