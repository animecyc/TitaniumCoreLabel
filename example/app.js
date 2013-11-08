/**
 * A Titanium label replacement made to be used with the TitaniumAnimator module
 *
 * Copyright (C) 2013 Seth Benjamin
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
var CoreLabel = require('com.animecyc.corelabel'),
	mainWindow = Ti.UI.createWindow({
		backgroundColor : 'white'
	}),
	testLabel = CoreLabel.createLabel({
		text : 'Core Label',
		color : 'blue',
		font : {
			fontFamily : 'HelveticaNeue-Light',
			fontSize : 30
		}
	});

mainWindow.add(testLabel);
mainWindow.open();