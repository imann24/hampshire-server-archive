/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function toggleDropdown () {
    var className = null;
    if ($('#dropdown').attr('class') === 'active') {
        className = "inactive";
    } else {
        className = "active";
    }
    
    setClass('#dropdown', className);
    setClass('#game-dev-title', className);
    
}

function popOut (elementId) {
    if ($("#" + elementId).attr("class") === "fullscreen-panel") {
        $(".fullscreen-panel").each(function() {
           if ($(this).attr('id') === elementId) {
               maximizeFullScreenPanel($(this).attr('id'));
           } else {
               hideFullScreenPanel($(this).attr('id'));
           }  
        });
        
        toggleBackButton(false);
        
    } else {
        $(".fullscreen-panel-hidden").each(function() {
            normalizeFullScreenPanel($(this).attr('id'));
        });
        
        $(".fullscreen-panel-max").each(function() {
            normalizeFullScreenPanel($(this).attr('id'));
        });
        
        toggleBackButton(true);
    }
}

function toggleBackButton (active) {
    if (active) {
        $("#back-button-hidden").attr("id", "back-button");
    } else {
        $("#back-button").attr("id", "back-button-hidden");
    }
}

function hideFullScreenPanel (id) {
    setClass("#" + id, "fullscreen-panel-hidden");
}

function maximizeFullScreenPanel (id) {
    setClass("#" + id, "fullscreen-panel-max");
}

function normalizeFullScreenPanel (id) {
    setClass("#" + id, "fullscreen-panel");
}

$(".collapsible").click(function() {
    if ($(this).attr("id") === "inactive") {
        $(this).attr("id", "active");
    } else if ($(this).attr("id") === "active") {
        $(this).attr("id", "inactive");
    }
});

function setClass (elementName, className) {
    $(elementName).removeClass();
    $(elementName).addClass(className);
}

