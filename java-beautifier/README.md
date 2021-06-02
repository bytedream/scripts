## Java beautifier

Makes java code look like it should.

#### Usage

Beautifies a java file.
```
./java-beautifier.py <a java file>
```

#### Example

1. Create `Main.java` with the content
    ```java
    public class Main {
    
        public static void main(String[] args) {
            System.out.println("I'm so beautiful");
        }
    
        public static class UnnecessarySubClass {
            public static void unnecessaryVoid() {
                System.out.println("Hello, i'm unnecessary");
            }
        }
    
    }
    ```

2. Beautify the file: `./java-beautifier.py Main.java`

3. Look at the beautiful output
    ```java
    public class Main                             {
    public static void main(String[] args)        {
    System.out.println("I'm so beautiful");       }
    public static class UnnecessarySubClass       {
    public static void unnecessaryVoid()          {
    System.out.println("Hello, i'm unnecessary"); }}}
    ```
