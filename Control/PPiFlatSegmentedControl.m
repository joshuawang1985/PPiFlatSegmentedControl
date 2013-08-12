//
//  PPiFlatSwitch.m
//  PPiFlatSwitch
//
//  Created by Pedro Piñera Buendía on 12/08/13.
//  Copyright (c) 2013 PPinera. All rights reserved.
//

#import "PPiFlatSegmentedControl.h"
#define segment_corner 3.0

@interface PPiFlatSegmentedControl()
@property (nonatomic,strong) NSMutableArray *segments;
@property (nonatomic) NSUInteger currentSelected;
@property (nonatomic,strong) NSMutableArray *separators;
@property (nonatomic,copy) selectionBlock selBlock;
@end


@implementation PPiFlatSegmentedControl
@synthesize  segments=_segments;
@synthesize selectedColor=_selectedColor;
@synthesize color=_color;
@synthesize textColor=_textColor;
@synthesize selectedTextColor=_selectedTextColor;
@synthesize borderColor=_borderColor;
@synthesize currentSelected=_currentSelected;
@synthesize textFont=_textFont;
@synthesize separators=_separators;
@synthesize borderWidth=_borderWidth;
@synthesize selBlock=_selBlock;

- (id)initWithFrame:(CGRect)frame andItems:(NSArray*)items andSelectionBlock:(selectionBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        //Selection block
        _selBlock=block;
        
        //Background Color
        self.backgroundColor=[UIColor clearColor];
        
        //Generating segments
        float buttonWith=frame.size.width/items.count;
        int i=0;
        for(NSString *item in items){
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(buttonWith*i, 0, buttonWith, frame.size.height);
            [button setTitle:item forState:UIControlStateNormal];
            [button setTitle:item forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            //Adding to self view
            [self.segments addObject:button];
            [self addSubview:button];
            
            
            //Adding separator
            if(i!=0){
                UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(i*buttonWith, 0, self.borderWidth, frame.size.height)];
                [self addSubview:separatorView];
                [self.separators addObject:separatorView];
            }
            
            i++;
        }
        
        //Applying corners
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=segment_corner;
        
        //Default selected 0
        _currentSelected=0;
    }
    return self;
}
#pragma mark - Lazy instantiations
-(NSMutableArray*)segments{
    if(!_segments)_segments=[[NSMutableArray alloc] init];
    return _segments;
}
-(NSMutableArray*)separators{
    if(!_separators)_separators=[[NSMutableArray alloc] init];
    return _separators;
}
#pragma mark - Actions
-(void)segmentSelected:(id)sender{
    if(sender){
        NSUInteger selectedIndex=[self.segments indexOfObject:sender];
        [self setEnabled:YES forSegmentAtIndex:selectedIndex];
        
        //Calling block
        if(self.selBlock){
            self.selBlock(selectedIndex);
        }
    }
}
#pragma mark - Getters
-(BOOL)isEnabledForSegmentAtIndex:(NSUInteger)index{
    return (index==self.currentSelected);
}

#pragma mark - Setters
-(void)updateSegmentsFormat{
    //Setting border color
    if(self.borderColor){
        self.layer.borderWidth=self.borderWidth;
        self.layer.borderColor=self.borderColor.CGColor;
    }else{
        self.layer.borderWidth=0;
    }
    
    //Updating segments color
    for(UIView *separator in self.separators){
        separator.backgroundColor=self.borderColor;
        separator.frame=CGRectMake(separator.frame.origin.x, separator.frame.origin.y,self.borderWidth , separator.frame.size.height);
    }
    
    //Modifying buttons with current State
    for (UIButton *segment in self.segments){
        [segment.titleLabel setFont:self.textFont];
        if([self.segments indexOfObject:segment]==self.currentSelected){
            //Selected-one
            [segment setBackgroundColor:self.selectedColor];
            [segment setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
            [segment setTitleColor:self.selectedTextColor forState:UIControlStateHighlighted];

        }else{
            //Non selected
            [segment setBackgroundColor:self.color];
            [segment setTitleColor:self.textColor forState:UIControlStateNormal];
            [segment setTitleColor:self.textColor forState:UIControlStateHighlighted];
        }
    }
}
-(void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor=selectedColor;
    [self updateSegmentsFormat];
}
-(void)setColor:(UIColor *)color{
    _color=color;
    [self updateSegmentsFormat];
}
-(void)setTextColor:(UIColor *)textColor{
    _textColor=textColor;
    [self updateSegmentsFormat];
}
-(void)setSelectedTextColor:(UIColor *)selectedTextColor{
    selectedTextColor=_selectedTextColor;
    [self updateSegmentsFormat];
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth=borderWidth;
    [self updateSegmentsFormat];
}
-(void)setTitle:(NSString*)title forSegmentAtIndex:(NSUInteger)index{
    //Getting the Segment
    if(index<self.segments.count){
        UIButton *segment=self.segments[index];
        [segment setTitle:title forState:UIControlStateNormal];
        [segment setTitle:title forState:UIControlStateHighlighted];
    }
}
-(void)setTextFont:(UIFont *)textFont{
    _textFont=textFont;
    [self updateSegmentsFormat];
}
-(void)setBorderColor:(UIColor *)borderColor{
    //Setting boerder color to all view
    _borderColor=borderColor;
    [self updateSegmentsFormat];
}
-(void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment{
    if(enabled){
        self.currentSelected=segment;
        [self updateSegmentsFormat];
    }
}
@end


/*
 // Create the path (with only the top-left corner rounded)
 UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerTopLeft| UIRectCornerTopRight                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
 // Create the shape layer and set its path
 CAShapeLayer *maskLayer = [CAShapeLayer layer];
 maskLayer.frame = imageView.bounds;
 maskLayer.path = maskPath.CGPath;
 // Set the newly created shape layer as the mask for the image view's layer
 imageView.layer.mask = maskLayer;*/
