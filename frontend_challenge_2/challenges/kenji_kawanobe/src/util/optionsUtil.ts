import {
  areaTypes,
  companyTypes,
  planTypes,
  ISimulation,
  SelectOption,
} from "@/types";

export function getCompanyOptions(area: areaTypes): SelectOption[] {
  const options: SelectOption[] = [];
  if (area === areaTypes.OTHER) {
    return options;
  }
  if (area === areaTypes.TOKYO) {
    options.push({
      value: companyTypes.TOKYO_DENRYOKU,
      label: companyTypes.TOKYO_DENRYOKU,
      selected: true,
    });
  } else if (area === areaTypes.KANSAI) {
    options.push({
      value: companyTypes.KANSAI_DENRYOKU,
      label: companyTypes.KANSAI_DENRYOKU,
      selected: true,
    });
  }
  options.push({ value: companyTypes.OTHER, label: companyTypes.OTHER });
  return options;
}

export function getPlanOptions(
  company?: companyTypes
): (SelectOption & { explain: string })[] {
  const options: (SelectOption & { explain: string })[] = [];
  if (company === companyTypes.TOKYO_DENRYOKU) {
    options.push({
      value: planTypes.PLAN_B,
      label: planTypes.PLAN_B,
      explain: `${planTypes.PLAN_B}の説明`,
      selected: true,
    });
    options.push({
      value: planTypes.PLAN_C,
      label: planTypes.PLAN_C,
      explain: `${planTypes.PLAN_C}の説明`,
    });
  } else if (company === companyTypes.KANSAI_DENRYOKU) {
    options.push({
      value: planTypes.PLAN_A,
      label: planTypes.PLAN_A,
      explain: `${planTypes.PLAN_A}の説明`,
      selected: true,
    });
    options.push({
      value: planTypes.PLAN_B,
      label: planTypes.PLAN_B,
      explain: `${planTypes.PLAN_B}の説明`,
    });
  }
  return options;
}

export function getAmpsOption(simulationData: ISimulation): SelectOption[] {
  if (simulationData.company === companyTypes.TOKYO_DENRYOKU) {
    if (simulationData.plan === planTypes.PLAN_B) {
      return ["10A", "15A", "20A", "30A", "40A", "50A", "60A"].map(
        (elm, index) => {
          return {
            value: elm,
            label: elm,
            selected: index === 0,
          };
        }
      );
    } else if (simulationData.plan === planTypes.PLAN_C) {
      return Array(40).map((_, index) => {
        return {
          value: index + 6 + "kVA",
          label: index + 6 + "kVA",
          selected: index === 0,
        };
      });
    }
  } else if (
    simulationData.company === companyTypes.KANSAI_DENRYOKU &&
    simulationData.plan === planTypes.PLAN_B
  ) {
    return Array(40).map((_, index) => {
      return {
        value: index + 6 + "kVA",
        label: index + 6 + "kVA",
        selected: index === 0,
      };
    });
  }
  return [];
}
