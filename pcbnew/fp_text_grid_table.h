/*
 * This program source code file is part of KiCad, a free EDA CAD application.
 *
 * Copyright (C) 2018-2023 KiCad Developers, see AUTHORS.txt for contributors.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, you may find one here:
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 * or you may search the http://www.gnu.org website for the version 2 license,
 * or you may write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
 */

#ifndef FP_TEXT_GRID_TABLE_H
#define FP_TEXT_GRID_TABLE_H

#include <wx/grid.h>
#include <grid_tricks.h>
#include <pcb_field.h>
#include <validators.h>
#include <dialog_shim.h>


class PCB_BASE_FRAME;

enum FP_TEXT_COL_ORDER
{
    FPT_NAME,
    FPT_VALUE,
    FPT_SHOWN,
    FPT_WIDTH,
    FPT_HEIGHT,
    FPT_THICKNESS,
    FPT_ITALIC,
    FPT_LAYER,
    FPT_ORIENTATION,
    FPT_UPRIGHT,       // keep text upright when viewed from bottom or right of board
    FPT_XOFFSET,
    FPT_YOFFSET,
    FPT_KNOCKOUT,
    FPT_MIRRORED,

    FPT_COUNT          // keep as last
};


class FP_TEXT_GRID_TABLE : public wxGridTableBase, public std::vector<PCB_FIELD>
{
public:
    FP_TEXT_GRID_TABLE( PCB_BASE_FRAME* aFrame, DIALOG_SHIM* aDialog );
    ~FP_TEXT_GRID_TABLE();

    int GetNumberRows() override { return (int) size(); }
    int GetNumberCols() override { return FPT_COUNT; }

    wxString GetColLabelValue( int aCol ) override;

    bool IsEmptyCell( int row, int col ) override
    {
        return false;   // don't allow adjacent cell overflow, even if we are actually empty
    }

    bool CanGetValueAs( int aRow, int aCol, const wxString& aTypeName ) override;
    bool CanSetValueAs( int aRow, int aCol, const wxString& aTypeName ) override;
    wxGridCellAttr* GetAttr( int row, int col, wxGridCellAttr::wxAttrKind kind ) override;

    wxString GetValue( int aRow, int aCol ) override;
    bool GetValueAsBool( int aRow, int aCol ) override;
    long GetValueAsLong( int aRow, int aCol ) override;

    void SetValue( int aRow, int aCol, const wxString& aValue ) override;
    void SetValueAsBool( int aRow, int aCol, bool aValue ) override;
    void SetValueAsLong( int aRow, int aCol, long aValue ) override;

protected:
    void onUnitsChanged( wxCommandEvent& aEvent );

private:
    PCB_BASE_FRAME* m_frame;
    DIALOG_SHIM*    m_dialog;

    FIELD_VALIDATOR m_fieldNameValidator;
    FIELD_VALIDATOR m_referenceValidator;
    FIELD_VALIDATOR m_valueValidator;
    FIELD_VALIDATOR m_urlValidator;
    FIELD_VALIDATOR m_nonUrlValidator;

    wxGridCellAttr* m_readOnlyAttr;
    wxGridCellAttr* m_boolColAttr;
    wxGridCellAttr* m_orientationColAttr;
    wxGridCellAttr* m_layerColAttr;
    wxGridCellAttr* m_referenceAttr;
    wxGridCellAttr* m_valueAttr;
    wxGridCellAttr* m_footprintAttr;
    wxGridCellAttr* m_urlAttr;

    std::unique_ptr<NUMERIC_EVALUATOR>        m_eval;
    std::map< std::pair<int, int>, wxString > m_evalOriginal;
};


#endif  // FP_TEXT_GRID_TABLE_H
