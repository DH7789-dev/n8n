import LogsPanel from "./LogsPanel-CdN88nKM.js";
import { d as defineComponent, a3 as useWorkflowsStore, x as computed, e as createBlock, f as createCommentVNode, g as openBlock } from "./index-DBHDbzE8.js";
import "./RunData-XR8X1h8t.js";
import "./FileSaver.min-CR51_A-S.js";
import "./useKeybindings-C50Jq_TC.js";
import "./useExecutionHelpers-B8aZRV4L.js";
import "./ActionDropdown-D-0LGZDt.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "DemoFooter",
  setup(__props) {
    const workflowsStore = useWorkflowsStore();
    const hasExecutionData = computed(() => workflowsStore.workflowExecutionData);
    return (_ctx, _cache) => {
      return hasExecutionData.value ? (openBlock(), createBlock(LogsPanel, {
        key: 0,
        "is-read-only": true
      })) : createCommentVNode("", true);
    };
  }
});
export {
  _sfc_main as default
};
