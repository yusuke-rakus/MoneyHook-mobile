enum SortType {
  dateDesc("日付が新しい順"),
  dateAsc("日付が古い順"),
  amountAsc("収入が大きい順"),
  amountDesc("支出が大きい順");

  final String label;

  const SortType(this.label);
}
