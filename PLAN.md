# CGPixel

现代最新版的一些图形api, 包括vulkan/metal 都有相同的设计理念, opengl是基于状态机的渲染, vulkan是基于流程的, 都有一个commandbuffer, opengl在这一点上很不友好, 上线文绑定, 很容易出错, 
接下来两个计划:
把opengl的渲染流程改成和metal相似
把渲染任务全部放进队列异步执行
