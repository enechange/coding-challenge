export const isNumeric = (value: string): boolean => /^\d+$/.test(value);

export const isEmailPattern = (value: string): boolean => {
  const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  return emailPattern.test(value);
};
