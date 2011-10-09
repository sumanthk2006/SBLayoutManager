# SBLayoutManager
## A minimalist layout manager to augment Struts and Springs to support variable width and height UILabel elements.

Struts and springs - used correctly - can take you pretty far in most iOS interfaces.
However, there are times where more complex UIs need data-centric layouts that require manual code to support. 
This is why I developed SBLayoutManager.  It is NOT a complete layout manager like Core Animations constraints based manager or the new - and super cool - Cocoa Autolayout manager (which, unfortunately, neither are available on iOS). It is, however, a simple library that can handle some common use cases to augment your use of Struts and Springs.

## Example Usage

###  Variable Height Data with elements below

This is a really common use case which is not handled by struts and springs: you have a UILabel that spans multiple lines with other elements below.  Your only option is to manage this programmatically. Not the end of the world, but a pain, nonetheless.
SBLayoutManager handles this with minimal hassle: (note: ARC code sample)

``` objective-c

-(void) viewDidLoad
{
	[super viewDidLoad];
	
	_layoutManager = [SBLayoutManager layoutManagerWithRootView: [self view]];
	[_layoutManager viewIsVariableHeight: self.descriptionLabel];
	[_layoutManager view: self.footerLabel isBelowView: self.descriptionLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[_layoutManager layout];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[_layoutManager layout];
}

-(void) someMethodThatUpdatesTheDataBeingDisplayed
{
	self.descriptionLabel.text = @"New Long Text Goes Here"];
	[_layoutManager layout];
}

```

Now, everything is rearranged properly when the device is rotated and your data being displayed changes.

## Example Project

An iPhone sample project illustrating some common techniques is included.
Checkout the viewDidLoad of the ViewController class to see how the layout manager is configured.

## Dependencies

* [iOS 4.0+]
* No other external dependencies.  Copy the SBLayoutManager folder into your project and go.

### ARC Support

If you are using [Automatic Reference Counting (ARC)](http://clang.llvm.org/docs/AutomaticReferenceCounting.html) enabled, you will need to set the `-fno-objc-arc` compiler flag on all of the SBLayoutManager. To do this in Xcode, go to your active target and select the "Build Phases" tab. In the "Compiler Flags" column, set `-fno-objc-arc` for each of the SBLayoutManager source files.

## Contact

Steve Breen - breeno@me.com

## License

SBLayoutManager is available under the BSD license.
