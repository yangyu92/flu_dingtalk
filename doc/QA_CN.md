**！！！！请先看[文档](https://github.com/yangyu92/flu_dingtalk/master/README_CN.md)，再看常见Q&A，再查看issue，自我排查错误，方便你我他。依然无法解决的问题可以加群提问！！！！**

## 常见Q&A

* android无法判断是否安装时

```
从Android 11开始，需要在AndroidManifest.xml清单文件中加入query权限申请,
才能检测到手机上安装的三方应用包安装状态，在主工程的AndroidManifest.xml 中增加标签
<queries>
    <!-- 指定钉钉包名 -->
    <package android:name="com.alibaba.android.rimet" />
</queries>
``` 
