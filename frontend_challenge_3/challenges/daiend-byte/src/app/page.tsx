import { redirect } from 'next/navigation';

import { paths } from '@/config/paths';

export default function HomePage(): never {
    redirect(paths.simulation.electricity.getHref());
}
