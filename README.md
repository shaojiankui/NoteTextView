# NoteTextView
NoteTextView,UITextView子类化实现横格本,笔记本控件

# 说明 
有些字体位置计算还有偏差
![image](https://raw.githubusercontent.com/shaojiankui/NoteTextView/master/font.png)

# demo
![](https://raw.githubusercontent.com/shaojiankui/NoteTextView/master/demo.gif)

# 使用
same with UITextView,just added three propertys
	
	@property (nonatomic) CGFloat lineOffset;
	@property (strong, nonatomic) UIColor *rowColor;
	@property (strong, nonatomic) UIColor *paperColor;
