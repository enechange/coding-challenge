export function isValidZipCode(
  firstZipCode: string,
  secondZipCode: string
): boolean {
  return (
    !isNaN(Number(firstZipCode)) &&
    !isNaN(Number(secondZipCode)) &&
    firstZipCode.length === 3 &&
    (firstZipCode.slice(0, 1) === "1" || firstZipCode.slice(0, 1) === "5") &&
    secondZipCode.length === 4
  );
}
