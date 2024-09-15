/*
* This program source code file is part of KiCad, a free EDA CAD application.
*
* Copyright (C) 2023 KiCad Developers, see AUTHORS.txt for contributors.
*
* This program is free software: you can redistribute it and/or modify it
* under the terms of the GNU General Public License as published by the
* Free Software Foundation, either version 3 of the License, or (at your
* option) any later version.
*
* This program is distributed in the hope that it will be useful, but
* WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <string>
#include <vector>
#include <algorithm>

/**
 * @brief Parse a version string into a vector of integers
 * @param versionString The version string to parse
 * @return A vector of integers representing the version
*/
const std::vector<int> parseVersionString( const std::string& versionString );

/**
 * @brief Compare two version strings of the form "major.minor.patch.build"
 * @param aVersionStr1 The first version string
 * @param aVersionStr2 The second version string
 * @return true if aVersionStr1 <= aVersionStr2, false otherwise
*/
bool compareVersionStrings( const std::string& aVersionStr1, const std::string& aVersionStr2 );