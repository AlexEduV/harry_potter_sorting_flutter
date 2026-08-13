abstract class UseCaseNoParams<Output> {
  Output call();
}

abstract class UseCaseWithParams<Input, Output> {
  Output call(Input params);
}
