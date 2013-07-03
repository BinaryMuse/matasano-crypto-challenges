function run_one {
  echo "=========================="
  echo "$0 $1:"
  $0 $1
}

case $1 in
--help|-h|help|"")
  echo "Specify an exercise number; for example, to run exercise 1, run '$0 01'"
  echo "Alternatively, run the DocTests with '$0 tests'"
  exit 1
  ;;
test|tests)
  elixir -r "lib/*.ex" tests.exs
  ;;
all)
  run_one "tests"
  for exercise in $(seq 1 8); do
    run_one $exercise
  done
  ;;
*)
  EXERCISE=$(printf "%02d" $(( 10#$1 )) )
  elixir -r "lib/*.ex" "$EXERCISE"_*.exs
  ;;
esac
