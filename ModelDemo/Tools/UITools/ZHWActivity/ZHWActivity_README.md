# ZHWActivity

1.状态出现，锁住屏幕，但是不锁导航条

2.状态样式需要自定义图



使用方式

1.将custom文件下的文件导入项目

2.调用状态

 if (![[ZHWActivity getActivity]isAnimating]) {
        
        [[ZHWActivity getActivity]startActivity:self.view AnimatingValue:2 bufferWidth:50 bufferHeight:50];
    }
    
3.关闭状态

    [[ZHWActivity getActivity]stopAnimating];


