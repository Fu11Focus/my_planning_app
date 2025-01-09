-keep class com.google.common.reflect.TypeToken
-keep class * extends com.google.common.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type

# Flutter-specific rules
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Keep stacktrace for easier debugging
-keepattributes SourceFile,LineNumberTable

# Keep Play Core SplitCompat classes
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-dontwarn com.google.android.play.core.**

# Awesome Notifications
-keep class me.carda.awesome_notifications.** { *; }
-keepclassmembers class me.carda.awesome_notifications.** { *; }
-keepattributes *Annotation*
# Retain generic signatures of TypeToken and its subclasses with R8 version 3.0 and higher.
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken
