
# Abstract

General information about module <code>Looker</code>.

The module is a collection of light-weight routines to traverse complex data structure. The module `Looker` provides advanced tools for a complete structural analysis of the input data at all levels of nesting. Use it to make easier comparison and operation on several similar data structures.

## Class diagram

![ClassDiagram.png](../../images/ClassDiagram.png)

The diagram above displays the connections between classes `Looker`, [`Replicator`](https://github.com/Wandalen/wReplicator), [`Selector`](https://github.com/Wandalen/wSelector), [`Resolver`](https://github.com/Wandalen/wResolver) and [`Equaler`](https://github.com/Wandalen/wEqualer). The solid lines indicate inheritance between classes, where the arrow indicates the parent class. The dashed lines indicate the use of classes, where the arrow indicates the class used by another. The diagram shows that the `Looker` is basic class, and it inherited by `Replicator`, `Selector` and `Equaler`. At the same time, `Selector` uses `Replicator`, and `Equaler` uses `Selector`. Class `Resolver` has only one connection, it inherits `Selector`.

The class `Looker` is used by other modules to perform analysis of data structures. For example, see module [Comparator](https://github.com/Wandalen/wComparator) which uses module `Looker` for comparison of two data structure.

[Back to content](../README.md#Tutorials)
