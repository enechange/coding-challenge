export const Badge: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <span className="bg-red-400 text-white p-1 rounded">
    {children}
  </span>
)
