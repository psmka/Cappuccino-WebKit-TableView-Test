/*
 * AppController.j
 * Cappucciono-WebKit-TableView-Test
 *
 * Created by You on February 22, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>


@implementation ColorItem : CPObject
{
	CPString    color   @accessors;
	CPNumber    ID      @accessors;
}

+(ColorItem) initWithID:(CPNumber) ID
               andColor:(CPString) color {
    var item = [[ColorItem alloc] init];
    [item setID:ID];
    [item setColor:color];
    return item;
}

-(id) init
{
	if(self = [super init]){
        [self setColor: @""];
        [self setID: [CPNumber numberWithInt:0]];
	}
	return self;
}

@end


@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
    @outlet CPTableView tableView;
    
    CPArray     colors;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.
    
    colors = [CPArray arrayWithObjects: [ColorItem initWithID: [CPNumber numberWithInt: 4] andColor:@"orange"],
                                        [ColorItem initWithID: [CPNumber numberWithInt: 3] andColor:@"clear" ],
                                        [ColorItem initWithID: [CPNumber numberWithInt: 2] andColor:@"orange" ],
                                        [ColorItem initWithID: [CPNumber numberWithInt: 1] andColor:@"orange" ],
                                        [ColorItem initWithID: [CPNumber numberWithInt: 8] andColor:@"clear" ],nil];
    [self createTableView];

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
}

-(CPTextField) getTextFieldCell
{
    var dataView = [CPTextField new];
    [dataView setAlignment:CPLeftTextAlignment];
    [dataView setLineBreakMode:CPLineBreakByTruncatingTail];
    [dataView setValue:[CPColor colorWithHexString:@"6a6a6a"] forThemeAttribute:@"text-color"];
    [dataView setValue:[CPColor blackColor] forThemeAttribute:@"text-color" inState:CPThemeStateSelectedDataView];
    [dataView setValue:[CPFont boldSystemFontOfSize:12] forThemeAttribute:@"font" inState:CPThemeStateSelectedDataView];
    [dataView setValue:CGInsetMake(0,10,0,0) forThemeAttribute:@"content-inset"];
    [dataView setValue:CPCenterVerticalTextAlignment forThemeAttribute:@"vertical-alignment"];
	return dataView;
}


-(void) createTableView
{
    var desc = [CPSortDescriptor sortDescriptorWithKey:@"ID" ascending:YES],
        tc = [[CPTableColumn alloc] initWithIdentifier:"ID"];
    
    [[tc headerView] setStringValue:"ID"];
	[tc setDataView: [self getTextFieldCell]];
    [tc setEditable:NO];
    [tc setSortDescriptorPrototype:desc];
    [tc setResizingMask:CPTableColumnAutoresizingMask | CPTableColumnUserResizingMask];
    [tableView addTableColumn:tc];
    
    var desc = [CPSortDescriptor sortDescriptorWithKey:@"color" ascending:YES],
        tc = [[CPTableColumn alloc] initWithIdentifier:"color"];
    
    [[tc headerView] setStringValue:"Color"];
	[tc setDataView: [self getTextFieldCell]];
    [tc setEditable:NO];
    [tc setSortDescriptorPrototype:desc];
    [tc setResizingMask:CPTableColumnAutoresizingMask | CPTableColumnUserResizingMask];
    [tableView addTableColumn:tc];

    [tableView setTarget:self];
	[tableView setDataSource:self];
	[tableView setDelegate:self];
    [tableView setUsesAlternatingRowBackgroundColors:YES];
    [tableView setIntercellSpacing:CGSizeMake(0,0)];
    
}

// TableView datasource
- (int) numberOfRowsInTableView:(CPTableView) aTableView
{
    CPLog.trace(@"TabelView - numberOfRowsInTableView - " + [colors count]);

    return [colors count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aColumn row:(int)aRow
{
    CPLog.trace(@"TabelView - objectValueForTableColumn - " + aRow + ":" + [[colors objectAtIndex: aRow] color]);
    if([[aColumn identifier] isEqualToString:@"color"]){
		return [[colors objectAtIndex: aRow] color];
    } else if([[aColumn identifier] isEqualToString:@"ID"]){
		return [[colors objectAtIndex: aRow] ID];
    }
}


- (void)tableView:(CPTableView)aTableView sortDescriptorsDidChange:(CPArray)oldDescriptors
{
	CPLog.trace(@"TabelView - sortDescriptorsDidChange");
    var newDescriptors = [aTableView sortDescriptors];
    [colors sortUsingDescriptors:newDescriptors];
    [tableView reloadData];
    [tableView deselectAll];
}


// TableView Delegate

-(id)tableView:(CPTableView) aTableView willDisplayView:(CPView) cell forTableColumn:(CPTableColumn) aColumn row:(int)aRow
{
    if([[aColumn identifier] isEqualToString:@"color"]){
        if([[[colors objectAtIndex: aRow] color] isEqualToString: @"orange"]){
            [cell setBackgroundColor:[CPColor orangeColor]];
        } else {
            [cell setBackgroundColor:[CPColor clearColor]];            
        }
    }
}


@end
