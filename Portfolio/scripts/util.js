/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * @description Used to format strings correctly
 * @returns {StringFormatter}
 * @constructor
 */
function StringFormatter () {}

/**
 * @description Repeats the string a set amount of times
 * @param {String} string
 * @param {int} count
 * @returns {String}
 */
StringFormatter.prototype.repeat = function (string, count) {
    var stringToReturn = "";
    for (var i = 0; i < count; i++) {
        stringToReturn += string;
    }
    return stringToReturn;
};