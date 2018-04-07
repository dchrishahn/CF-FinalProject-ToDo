//
//  CF_FinalProject_ToDoUITests.swift
//  CF-FinalProject-ToDoUITests
//
//  Created by Chris Hahn on 1/25/18.
//  Copyright © 2018 Sturnella. All rights reserved.
//

import XCTest

class CF_FinalProject_ToDoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateList() {
        
        let app = XCUIApplication()
        app.navigationBars["ToDo Lists"].buttons["NewList"].tap()
        
        let enterNewToDoListTextField = app.textFields["enter new to-do list"]
        enterNewToDoListTextField.tap()
        enterNewToDoListTextField.typeText("new list")
        
        let cfFinalprojectTodoDataentryNavigationBar = app.navigationBars["CF_FinalProject_ToDo.DataEntry"]
        cfFinalprojectTodoDataentryNavigationBar.buttons["Save"].tap()
        cfFinalprojectTodoDataentryNavigationBar.buttons["Done"].tap()
        
        XCTAssert(app.staticTexts["new list"].exists)
        
    }
 
    func testCreateListTwo() {
        
        let app = XCUIApplication()
        app.navigationBars["ToDo Lists"].buttons["NewList"].tap()
        
        let enterNewToDoListTextField = app.textFields["enter new to-do list"]
        enterNewToDoListTextField.tap()
        enterNewToDoListTextField.typeText("new list two")
        
        let cfFinalprojectTodoDataentryNavigationBar = app.navigationBars["CF_FinalProject_ToDo.DataEntry"]
        cfFinalprojectTodoDataentryNavigationBar.buttons["Save"].tap()
        cfFinalprojectTodoDataentryNavigationBar.buttons["Done"].tap()
        
        XCTAssert(app.staticTexts["new list two"].exists)
        
    }
    
    func testDeleteList() {
        
        let app = XCUIApplication()
        let todoListsNavigationBar = app.navigationBars["ToDo Lists"]
        todoListsNavigationBar.buttons["Edit"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete new list"]/*[[".cells.buttons[\"Delete new list\"]",".buttons[\"Delete new list\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.buttons["Delete"].tap()
        todoListsNavigationBar.buttons["Done"].tap()
        XCUIDevice.shared.orientation = .faceUp
        
        XCTAssertFalse(app.staticTexts["new list"].exists)
    }
 
    
    func testCreateTask() {
    
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["new list two"]/*[[".cells.staticTexts[\"new list two\"]",".staticTexts[\"new list two\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let tasksNavigationBar = app.navigationBars["Tasks"]
        tasksNavigationBar.buttons["NewTask"].tap()
        
        let addTaskAlert = app.alerts["Add Task"]
        let enterTaskDescriptionTextField = addTaskAlert.collectionViews.textFields["enter task description"]
        enterTaskDescriptionTextField.typeText("new task")

        addTaskAlert.buttons["Save"].tap()
        
        XCTAssert(app.staticTexts["new task"].exists)
        
        tasksNavigationBar.buttons["ToDo Lists"].tap()
        
    }
    
}
