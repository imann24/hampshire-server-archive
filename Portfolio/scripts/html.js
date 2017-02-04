/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * @description Used to save and parse HTML to the page with JS
 * @param {String} className The class of the element
 * @param {String} idName The id of the element
 * @returns {HTMLElement}
 * @constructor
 */
function HTMLElement (className, idName) {
    this.initialize(className, idName);
}


/**
 * @description Called as the constructor so this class can easily be subclassed
 * @param {String} className
 * @param {String} idName
 * @returns {undefined}
 */
HTMLElement.prototype.initialize = function (className, idName) {
    
    // Should be an array of Attributes
    this.attributes = [];
    
    // Should be an array of HTMLElements
    this.innerContent = [];
    
    this.className = 
            typeof className === "undefined" ?
                "" : className;
     
    this.idName = 
            typeof idName === "undefined" ?
                "" : idName;
                
    if (typeof className !== "undefined") {
        this.addAttribute(
            new Attribute(
                "class", className        
            )
        );
    }
    
    if (typeof idName !== "undefined") {
        this.addAttribute(
            new Attribute(
                "id", idName        
            )
        );
    }
            
    this.type = null;
    
    this.text = "";
};


/**
 * @description Used if you want the tags to be something other than div
 * @param {String} type
 * @returns {undefined}
 */
HTMLElement.prototype.setStype = function (type) {
    this.type = type;
};

/**
 * @description Fetches the type of this element (div by default)
 * @returns {String}
 */
HTMLElement.prototype.getType = function () {
    return this.type === null ? "div" : this.type;
};

/**
 * @description Fetches the HTML code needed to generate page text
 * @returns {String}
 */
HTMLElement.prototype.getHTML = function () {
    return this.openingTag(this) +
            this.getInnerContent() +
            this.closingTag(this);
};

/**
 * @description To be called recursively to fetch nested elements in the HTML
 * @returns {String}
 */
HTMLElement.prototype.getInnerContent = function () {
    if (this.innerContent !== null) {
        var html = this.text;
        
        for (var i = 0; i < this.innerContent.length; i++) {
            html += this.innerContent[i].getHTML();
        }
        
        return html;
    } else {
        return "";
    }
};

/**
 * @description Formats the opening tag of this HTML Element
 * @param {HTMLElement} htmlElement
 * @returns {String}
 */
HTMLElement.prototype.openingTag = function (htmlElement) {
    return "<" + 
            htmlElement.getType() +
            " " + htmlElement.getAttributes() +
            ">";
};

/**
 * @description Formats the closing tag of this HTML element
 * @param {HTMLElement} htmlElement
 * @returns {String}
 */
HTMLElement.prototype.closingTag = function (htmlElement) {
    return "</" + htmlElement.getType() + ">";
};

/**
 * @description Adds an inner element to the current HTML element
 * @param {HTMLElement} htmlElement
 * @returns {undefined}
 */
HTMLElement.prototype.addInnerElement = function (htmlElement) {
    this.innerContent.push(htmlElement);
};

/**
 * @description Adds an attribute to the opening tag of the current HTMLElement
 * @param {Attribute} attribute
 * @returns {undefined}
 */
HTMLElement.prototype.addAttribute = function (attribute) {
    this.attributes.push(attribute);
};

/**
 * @description Returns an HTML formatted string of all the attributes of an element
 * @param {HTMLElement} htmlElement
 * @returns {String}
 */
HTMLElement.prototype.getAttributes = function (htmlElement) {
    if (typeof htmlElement === "undefined") {
        htmlElement = this;
    }
    
    var attributes = "";
    
    for (var i = 0; i < htmlElement.attributes.length; i++) {
        attributes += htmlElement.attributes[i].getHTML();
    }
    
    return attributes;
};

/**
 * @description Adds text that appears at the end of the HTML element's current text
 * @param {String} text
 * @returns {undefined}
 */
HTMLElement.prototype.appendText = function (text) {
    this.text += text;
};

/**
 * @description Adds text that appears at the beginning of the HTML element's current text
 * @param {String} text
 * @returns {undefined}
 */
HTMLElement.prototype.prependText = function (text) {
    this.text = text + this.text;
};

/**
 * @description Overwrites the current text of the HTMLElement
 * @param {String} text
 * @returns {undefined}
 */
HTMLElement.prototype.setText = function (text) {
    this.text = text;
};

/**
 * @description Subclass of HTMLElement, includes the possibility to wrap it in a tags
 * @param {String} className
 * @param {String} idName
 * @param {String} link
 * @returns {LinkableElement}
 * @constructor
 */
function LinkableElement (className, idName, link, newTab) {
    this.initialize(className, idName, link, newTab);
};

LinkableElement.prototype = new HTMLElement();

/**
 * @description Called in the constructor, initializes the class
 * @param {String} className
 * @param {String} idName
 * @param {String} link
 * @returns {undefined}
 */
LinkableElement.prototype.initialize = function (className, idName, link, newTab) {
    HTMLElement.prototype.initialize.call(this, className, idName);
    
    this.link = null;
    this.newTab = newTab;
    if (typeof link !== "undefined") {
        this.setLink(link);
    }
};

/**
 * @description Sets the link of the element
 * @param {String} link
 * @returns {undefined}
 */
LinkableElement.prototype.setLink = function (link, newTab) {
    this.link = link;
    if (newTab === true) {
        this.setOpenNewTab(true);
    }
};

LinkableElement.prototype.setOpenNewTab = function () {
    this.newTab = true;
};

/**
 * @description Gets the HTML of this element
 * @param {HTMLElement} htmlElement
 * @returns {String}
 */
LinkableElement.prototype.getHTML = function (htmlElement) {    
    if (typeof htmlElement === "undefined") {
        htmlElement = this;
    }
    
    var html = HTMLElement.prototype.getHTML.call(htmlElement);
    if (this.link !== null) {
        var linkElement = new HTMLElement ();
        linkElement.setStype("a");
        linkElement.addAttribute(
            new Attribute (
                "href",
                htmlElement.link
            )
        ); 

        if (this.newTab === true) {
            linkElement.addAttribute(
                        new Attribute (
                            "target",
                            "blank"
                        )
                    );   
        }
        html = this.openingTag(linkElement) + html + this.closingTag(linkElement);
    }
    return html;
};

/**
 * @description Adds an attribute to the element, different behavior if attribute is href
 * @param {Attribute} attribute
 * @returns {undefined}
 */
LinkableElement.prototype.addAttribute = function (attribute) {
    if (attribute.key === "href") {
        this.setLink(attribute.value);
    } else {
        HTMLElement.prototype.addAttribute.call(this, attribute);
    }
};

/**
 * @description An image element
 * @param {String} imageURL
 * @param {String} className
 * @param {String} idName
 * @returns {ImageElement}
 * @constructor
 */
function ImageElement (imageURL, className, idName) {
    this.initialize(imageURL, className, idName);
}

ImageElement.prototype = new LinkableElement();

/**
 * @description Initializes the class, called from the constructor
 * @param {String} imageURL
 * @param {String} className
 * @param {String} idName
 * @returns {undefined}
 */
ImageElement.prototype.initialize = function (imageURL, className, idName) {
    LinkableElement.prototype.initialize(this, className, idName, true);    
    this.imageURL = imageURL;
};

/**
 * @description Returns the image
 * @returns {String}
 */
ImageElement.prototype.getInnerContent = function () {
    return "<img src = " + this.imageURL + ">";
};

/**
 * @description A group of ImageElements
 * @param {String[]} imageURLs
 * @param {String} className
 * @param {String} idName
 * @returns {ImageGroup}
 * @constructor
 */
function ImageGroup (imageURLs, className, idName) {
    this.initialize (
        imageURLs,
        className,
        idName
    );
}

ImageGroup.prototype = new HTMLElement();

/**
 * @description Initializes the class
 * @param {String[]} imageURLs
 * @param {String} className
 * @param {String} idName
 * @returns {undefined}
 */
ImageGroup.prototype.initialize = function (imageURLs, className, idName) {
    HTMLElement.prototype.initialize(this, className, idName);
    this.images = this.createImages(imageURLs);
};

/**
 * @description Creates the images from their URL's
 * @param {String[]} imageURLs
 * @returns {ImageElement[]}
 */
ImageGroup.prototype.createImages = function (imageURLs) {
    var images = [];
   
    for (var i = 0; i < imageURLs.length; i++) {
        images.push (
            new ImageElement (
                imageURLs[i],
                this.className,
                this.idName
            )
        );
    }
    return images;
};

/**
 * @description Formats the group of images as HTML
 * @returns {String}
 */
ImageGroup.prototype.getHTML = function () {
    var html = this.openingTag(this);
    for (var i = 0; i < this.images.length; i++) {
        html += this.images[i].getHTML();
    }
    
    html += this.closingTag(this);
    
    return html;
};

/**
 * @description Adds links to all the images
 * @param {String[]} links
 * @returns {undefined}
 */
ImageGroup.prototype.addLinkToAll = function (links) {
    var isArray = Array.isArray(links);
    
    for (var i = 0; i < this.images.length; i++) {
        this.images[i].setLink(isArray ? links[i] : links, true);
    }
  
};

/**
 * @description An opening tag attribute
 * @param {String} key
 * @param {String} value
 * @returns {Attribute}
 * @constructor
 */
function Attribute (key, value) {
    this.initialize(key, value);
}

/**
 * @description Creates the attribute
 * @param {String} key
 * @param {String} value
 * @returns {undefined}
 */
Attribute.prototype.initialize = function (key, value) {
    this.key = key;
    this.value = value;
};

/**
 * @description Fetches the html code for the attribute
 * @returns {String}
 */
Attribute.prototype.getHTML = function () {
    return this.key + " = " + " '" + this.value + "' ";
};

/**
 * @description A collection of HTML Elements 
 * @param {String} innerClassName
 * @param {String[]} idNames
 * @param {String} outerClassName
 * @param {String} outerIdName 
 * @returns {HTMLGroup}
 * @constructor
 */
function HTMLGroup (innerClassName, idNames, outerClassName, outerIdName) {

    HTMLElement.prototype.initialize.call(this, outerClassName, outerIdName);

    this.innerClasName = 
            typeof innerClassName === "undefined" ?
                "" : innerClassName;
                
    this.idNames = idNames;
    
    this.innerContent = this.generateInnerHTMLElements();
}

HTMLGroup.prototype = new HTMLElement();

/**
 * @description Generates the inner HTML Elements
 * @returns {HTMLElement[]}
 */
HTMLGroup.prototype.generateInnerHTMLElements = function () {
    var innerElements = [];
    
    for (var i = 0; i < this.idNames.length; i++) {
        innerElements.push(
            new LinkableElement (
                this.innerClasName,
                this.idNames[i]
            )
        );
    }
    
    return innerElements;
};

/**
 * @description Adds an attribute to contained element
 * @param {String} key
 * @param {String[]} values
 * @returns {undefined}
 */
HTMLGroup.prototype.addAttributeToAll = function (key, values) {
    for (var i = 0; i < this.innerContent.length; i++) {
        this.innerContent[i].addAttribute (
            new Attribute (
                key,
                values[i]
            )
        );
    }
};

/**
 * @description Adds an inner element to all elements
 * @param {String} type
 * @param {String[]} content
 * @param {String} className
 * @param {String} idName
 * @returns {undefined}
 */
HTMLGroup.prototype.addInnerContentToAll = function (type, content, className, idName) {
    for (var i = 0; i < this.innerContent.length; i++) {
        var element = new HTMLElement (
                className,
                idName
            );
        
        element.setStype(type);
        element.setText(content[i]);
        
        this.innerContent[i].addInnerElement (element);
    }
};

/**
 * @description Adds a link to each element
 * @param {String[]} links
 * @returns {undefined}
 */
HTMLGroup.prototype.addLinkToAll = function (links) {
    for (var i = 0; i < this.innerContent.length; i++) {
        this.innerContent[i].addAttribute(
            new Attribute(
                "href",
                links[i]
            )
        );
    }
};

/**
 * @description Adds inner content to a specified element
 * @param {int} index
 * @param {HTMLElement | HTMLElement[]} htmlElements
 * @returns {undefined}
 */
HTMLGroup.prototype.addInnerContentToElement = function (index, htmlElements) {
    if (Array.isArray(htmlElements)) {
        for (var i = 0; i < this.htmlElements.length; i++) {
            this.innerContent[index].addInnerElement(
                htmlElements[i]
            );
        }
    } else {
        this.innerContent[index].addInnerElement(
            htmlElements
        );   
    }
};

/**
 * @description Used to format local links correctly
 * @returns {LinkFormatter}
 * @constructor
 */
function LinkFormatter () {}

/**
 * @description Used to move a link up a specified number of directory levels
 * @param {int} level
 * @param {String | String[]} links
 * @returns {String}
 */
LinkFormatter.prototype.setDirectoryLevel = function (level, links) {
    var directoryLevel = new StringFormatter().repeat("../", level);
    
    if (typeof links === "string") {
        return directoryLevel + links;
    } else if (Array.isArray(links)) {
        for (var i = 0; i < links.length; i++) {
            links[i] = directoryLevel + links[i];
        }
        return links;
    } else {
        console.log("Unreadeable link format");
    }
};

/**
 * @description Adds a directory to the link's address
 * @param {String} directory
 * @param {String | String[]} links
 * @returns {unresolved}
 */
LinkFormatter.prototype.addDirectory = function (directory, links) {
    directory += "/";
    
    if (typeof links === "string") {
        return directory + links;
    } else if (Array.isArray(links)) {
        for (var i = 0; i < links.length; i++) {
            links[i] = directory + links[i];
        }
        return links;
    } else {
        console.log("Unreadeable link format");
    }
};