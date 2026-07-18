(() => {
  "use strict";

  const sessionToken = document.querySelector('meta[name="orca-session-token"]').content;
  const state = { missions: [], current: null, selectedId: null, project: "", loading: false };
  const modalState = { action: null, context: {}, trigger: null };

  const dom = {
    loading: document.querySelector(".loading-view"),
    empty: document.querySelector(".empty-view"),
    missionView: document.querySelector(".mission-view"),
    missionList: document.querySelector(".mission-list"),
    railEmpty: document.querySelector(".rail-empty"),
    projectPath: document.querySelector(".project-path"),
    outcome: document.querySelector("#mission-outcome"),
    statusBadge: document.querySelector(".status-badge"),
    missionId: document.querySelector(".mission-id"),
    revision: document.querySelector(".revision-label"),
    nextAction: document.querySelector(".next-action"),
    readinessRing: document.querySelector(".readiness-ring"),
    readinessPercent: document.querySelector(".readiness-percent"),
    readinessCount: document.querySelector(".readiness-count"),
    blocker: document.querySelector(".blocker-banner"),
    blockerReason: document.querySelector(".blocker-reason"),
    criteriaSummary: document.querySelector(".criteria-summary"),
    criteriaList: document.querySelector(".criteria-list"),
    activityList: document.querySelector(".activity-list"),
    criterionTemplate: document.querySelector("#criterion-template"),
    modalBackdrop: document.querySelector(".modal-backdrop"),
    modal: document.querySelector(".modal"),
    modalTitle: document.querySelector("#modal-title"),
    modalDescription: document.querySelector("#modal-description"),
    modalKicker: document.querySelector(".modal-kicker"),
    form: document.querySelector(".action-form"),
    formFields: document.querySelector(".form-fields"),
    formError: document.querySelector(".form-error"),
    actorInput: document.querySelector(".actor-input"),
    modalSubmit: document.querySelector(".modal-submit"),
    toastRegion: document.querySelector(".toast-region"),
    refresh: document.querySelector(".refresh-button"),
    complete: document.querySelector(".complete-button"),
    addCriterion: document.querySelector(".add-criterion-button"),
    addNote: document.querySelector(".add-note-button"),
    block: document.querySelector(".block-button"),
    resume: document.querySelector(".resume-button"),
    reopen: document.querySelector(".reopen-button"),
    cancel: document.querySelector(".cancel-button")
  };

  const actionDefinitions = {
    create: {
      kicker: "New mission",
      title: "Define the outcome",
      description: "State one observable result, then list the proofs required before it can be called complete.",
      submit: "Create mission",
      fields: [
        { name: "outcome", label: "Outcome", placeholder: "Ship Orca 1.0 as a complete product", type: "textarea", required: true },
        { name: "criteria", label: "Acceptance criteria", hint: "One observable proof per line.", placeholder: "All product checks pass\nThe install works from a clean machine\nThe release is live", type: "textarea", required: true }
      ]
    },
    add: {
      kicker: "Acceptance contract",
      title: "Add a criterion",
      description: "Add a new observable proof without rewriting the mission history.",
      submit: "Add criterion",
      fields: [{ name: "criterion", label: "Criterion", placeholder: "The release installs from its published archive", type: "textarea", required: true }]
    },
    satisfy: {
      kicker: "Record proof",
      title: "Satisfy criterion",
      description: "Describe evidence that another person could inspect and understand.",
      submit: "Record evidence",
      fields: [{ name: "evidence", label: "Evidence", placeholder: "Install smoke passed against the published v1.0.0 archive", type: "textarea", required: true }]
    },
    check: {
      kicker: "Run proof",
      title: "Execute a check",
      description: "Run a command directly, without a shell. A zero exit code records command evidence.",
      submit: "Run check",
      fields: [{ name: "command", label: "Command", hint: "Quotes group arguments; shell operators are not evaluated.", placeholder: "./scripts/validate-repo.sh", type: "input", required: true }]
    },
    reset: {
      kicker: "Correct the record",
      title: "Reset criterion",
      description: "Remove its current evidence and return it to open. The reason remains in mission history.",
      submit: "Reset criterion",
      fields: [{ name: "reason", label: "Reason", placeholder: "The release artifact changed after this proof was recorded", type: "textarea", required: true }]
    },
    note: {
      kicker: "Mission context",
      title: "Add a note",
      description: "Capture a decision or handoff without changing readiness.",
      submit: "Add note",
      fields: [{ name: "summary", label: "Note", placeholder: "Release owner confirmed the distribution target", type: "textarea", required: true }]
    },
    block: {
      kicker: "Stop with cause",
      title: "Block the mission",
      description: "Name the condition preventing honest progress. Criteria cannot change until the blocker is resolved.",
      submit: "Block mission",
      fields: [{ name: "reason", label: "Blocker", placeholder: "Release signing authority is unavailable", type: "textarea", required: true }]
    },
    resume: {
      kicker: "Resume work",
      title: "Resolve the blocker",
      description: "Record how the blocking condition was resolved, then return the mission to active.",
      submit: "Resolve & resume",
      fields: [{ name: "reason", label: "Resolution", placeholder: "Signing authority approved the release", type: "textarea", required: true }]
    },
    cancel: {
      kicker: "Terminal decision",
      title: "Cancel the mission",
      description: "End this mission without claiming completion. It can be reopened later with an attributable reason.",
      submit: "Cancel mission",
      fields: [{ name: "reason", label: "Reason", placeholder: "The outcome was superseded by a different release strategy", type: "textarea", required: true }]
    },
    reopen: {
      kicker: "Correction path",
      title: "Reopen the mission",
      description: "Return a completed or canceled mission to active while preserving its full history.",
      submit: "Reopen mission",
      fields: [{ name: "reason", label: "Reason", placeholder: "A late requirement needs new proof", type: "textarea", required: true }]
    },
    complete: {
      kicker: "Terminal decision",
      title: "Complete the mission",
      description: "All criteria have evidence and no blocker remains. This records the outcome as complete.",
      submit: "Complete mission",
      fields: []
    }
  };

  function fieldElement(definition) {
    const label = document.createElement("label");
    label.className = "field";
    const title = document.createElement("span");
    title.textContent = `${definition.label}${definition.required ? " (required)" : ""}`;
    label.append(title);
    const input = document.createElement(definition.type === "textarea" ? "textarea" : "input");
    input.name = definition.name;
    input.placeholder = definition.placeholder || "";
    input.required = Boolean(definition.required);
    if (definition.type !== "textarea") input.type = "text";
    label.append(input);
    if (definition.hint) {
      const hint = document.createElement("small");
      hint.textContent = definition.hint;
      label.append(hint);
    }
    return label;
  }

  function openAction(action, context = {}, trigger = document.activeElement) {
    const definition = actionDefinitions[action];
    if (!definition) return;
    modalState.action = action;
    modalState.context = context;
    modalState.trigger = trigger;
    dom.modalKicker.textContent = definition.kicker;
    dom.modalTitle.textContent = definition.title;
    dom.modalDescription.textContent = definition.description;
    dom.modalSubmit.textContent = definition.submit;
    dom.formFields.replaceChildren(...definition.fields.map(fieldElement));
    dom.formError.hidden = true;
    dom.formError.textContent = "";
    dom.form.querySelectorAll('[aria-describedby="form-error"]').forEach((field) => field.removeAttribute("aria-describedby"));
    dom.actorInput.value = localStorage.getItem("orcaActor") || "Mission Control";
    dom.modalBackdrop.hidden = false;
    document.body.style.overflow = "hidden";
    requestAnimationFrame(() => {
      const target = dom.formFields.querySelector("input, textarea") || dom.actorInput;
      target.focus();
    });
  }

  function closeModal() {
    if (dom.modalBackdrop.hidden) return;
    dom.modalBackdrop.hidden = true;
    document.body.style.overflow = "";
    dom.form.reset();
    dom.formError.hidden = true;
    dom.modalSubmit.disabled = false;
    dom.modalSubmit.classList.remove("is-loading");
    modalState.trigger?.focus();
    modalState.action = null;
    modalState.context = {};
  }

  function showToast(message, error = false) {
    const toast = document.createElement("div");
    toast.className = `toast${error ? " is-error" : ""}`;
    toast.textContent = message;
    dom.toastRegion.append(toast);
    window.setTimeout(() => toast.remove(), 4200);
  }

  async function api(path, options = {}) {
    const response = await fetch(path, { cache: "no-store", ...options });
    const payload = await response.json().catch(() => ({ ok: false, error: "Mission Control returned unreadable data" }));
    if (!response.ok || !payload.ok) throw new Error(payload.error || `Request failed (${response.status})`);
    return payload;
  }

  async function loadState({ quiet = false } = {}) {
    if (state.loading) return;
    state.loading = true;
    dom.refresh.disabled = true;
    dom.refresh.classList.add("is-spinning");
    if (!quiet) {
      dom.loading.hidden = false;
      dom.empty.hidden = true;
      dom.missionView.hidden = true;
    }
    try {
      const query = state.selectedId ? `?mission=${encodeURIComponent(state.selectedId)}` : "";
      const payload = await api(`/api/state${query}`);
      state.missions = payload.missions;
      state.current = payload.current;
      state.project = payload.project;
      if (state.current) state.selectedId = state.current.id;
      render();
    } catch (error) {
      showToast(error.message, true);
      if (!quiet) {
        dom.loading.hidden = true;
        dom.empty.hidden = false;
      }
    } finally {
      state.loading = false;
      dom.refresh.disabled = false;
      dom.refresh.classList.remove("is-spinning");
    }
  }

  function render() {
    dom.projectPath.textContent = state.project;
    dom.projectPath.title = state.project;
    renderMissionList();
    updateCreateControls();
    dom.loading.hidden = true;
    if (!state.current) {
      dom.empty.hidden = false;
      dom.missionView.hidden = true;
      return;
    }
    dom.empty.hidden = true;
    dom.missionView.hidden = false;
    renderMission(state.current);
  }

  function updateCreateControls() {
    const activeWork = state.missions.find((mission) => mission.active && ["active", "blocked"].includes(mission.status));
    document.querySelectorAll(".new-mission-button, .empty-create-button, .empty-primary-button").forEach((button) => {
      button.disabled = Boolean(activeWork);
      button.title = activeWork ? `Complete or cancel ${activeWork.outcome} before creating another mission` : "Create a mission";
    });
  }

  function renderMissionList() {
    dom.missionList.replaceChildren();
    dom.railEmpty.hidden = state.missions.length !== 0;
    for (const mission of state.missions) {
      const button = document.createElement("button");
      button.type = "button";
      button.className = "mission-list-button";
      button.dataset.status = mission.status;
      button.setAttribute("aria-current", String(mission.id === state.selectedId));
      const dot = document.createElement("span");
      dot.className = "status-dot";
      dot.setAttribute("aria-hidden", "true");
      const copy = document.createElement("span");
      copy.className = "mission-list-copy";
      const outcome = document.createElement("strong");
      outcome.textContent = mission.outcome;
      const meta = document.createElement("span");
      const status = document.createElement("span");
      status.textContent = mission.status;
      const readiness = document.createElement("span");
      readiness.textContent = `${mission.readiness.percent}%`;
      meta.append(status, readiness);
      copy.append(outcome, meta);
      button.append(dot, copy);
      button.addEventListener("click", () => {
        state.selectedId = mission.id;
        loadState();
      });
      const listItem = document.createElement("div");
      listItem.setAttribute("role", "listitem");
      listItem.append(button);
      dom.missionList.append(listItem);
    }
  }

  function renderMission(mission) {
    const readiness = mission.readiness;
    const pointer = state.missions.find((item) => item.active);
    const isPointer = pointer?.id === mission.id;
    const activeStatus = mission.status === "active";
    const blockedStatus = mission.status === "blocked";
    const terminalStatus = ["completed", "canceled"].includes(mission.status);
    const otherWorkActive = pointer && pointer.id !== mission.id && ["active", "blocked"].includes(pointer.status);

    dom.outcome.textContent = mission.outcome;
    dom.statusBadge.textContent = mission.status;
    dom.statusBadge.dataset.status = mission.status;
    dom.missionId.textContent = mission.id;
    dom.revision.textContent = `r${mission.revision}`;
    dom.nextAction.textContent = mission.next_action;
    dom.readinessRing.style.setProperty("--readiness", `${readiness.percent}%`);
    dom.readinessPercent.textContent = `${readiness.percent}%`;
    dom.readinessCount.textContent = `${readiness.satisfied} / ${readiness.total}`;
    dom.criteriaSummary.textContent = `${readiness.satisfied} satisfied · ${readiness.total - readiness.satisfied} open`;

    const unresolved = mission.blockers.find((blocker) => !blocker.resolved_at);
    dom.blocker.hidden = !unresolved;
    dom.blockerReason.textContent = unresolved?.reason || "";

    dom.complete.hidden = !(isPointer && activeStatus);
    dom.complete.disabled = !readiness.ready_to_complete;
    dom.complete.title = readiness.ready_to_complete ? "Record this mission as complete" : "Every criterion needs evidence first";
    dom.addCriterion.hidden = !(isPointer && activeStatus);
    dom.addNote.hidden = !isPointer;
    dom.block.hidden = !(isPointer && activeStatus);
    dom.resume.hidden = !(isPointer && blockedStatus);
    dom.cancel.hidden = !(isPointer && (activeStatus || blockedStatus));
    dom.reopen.hidden = !terminalStatus;
    dom.reopen.disabled = Boolean(otherWorkActive);
    dom.reopen.title = otherWorkActive ? `Finish ${pointer.outcome} before reopening this mission` : "Return this mission to active";

    renderCriteria(mission, isPointer && activeStatus);
    renderActivity(mission.events);
  }

  function renderCriteria(mission, actionable) {
    dom.criteriaList.replaceChildren();
    for (const criterion of mission.criteria) {
      const node = dom.criterionTemplate.content.cloneNode(true);
      const row = node.querySelector(".criterion-row");
      const heading = node.querySelector(".criterion-heading");
      const id = heading.querySelector("code");
      const text = heading.querySelector("strong");
      const evidence = node.querySelector(".criterion-evidence");
      const actions = node.querySelector(".criterion-actions");
      const satisfied = criterion.status === "satisfied" && criterion.evidence.length > 0;
      row.classList.toggle("is-satisfied", satisfied);
      id.textContent = criterion.id;
      text.textContent = criterion.text;
      if (satisfied) {
        const latest = criterion.evidence[criterion.evidence.length - 1];
        const detail = document.createElement(latest.command ? "code" : "span");
        detail.textContent = latest.summary || `${latest.command} · exit ${latest.exit_code}`;
        const actor = document.createElement("span");
        actor.className = "evidence-actor";
        actor.textContent = ` — ${latest.actor}`;
        evidence.append(detail, actor);
      } else {
        evidence.textContent = "Evidence required";
      }
      if (actionable) {
        if (satisfied) {
          actions.append(criterionButton("Reset", () => openAction("reset", { criterion_id: criterion.id })));
        } else {
          actions.append(
            criterionButton("Run check", () => openAction("check", { criterion_id: criterion.id })),
            criterionButton("Record proof", () => openAction("satisfy", { criterion_id: criterion.id }))
          );
        }
      }
      dom.criteriaList.append(node);
    }
  }

  function criterionButton(label, handler) {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "criterion-button";
    button.textContent = label;
    button.addEventListener("click", handler);
    return button;
  }

  function renderActivity(events) {
    dom.activityList.replaceChildren();
    for (const event of [...events].reverse().slice(0, 24)) {
      const item = document.createElement("li");
      item.className = "activity-item";
      const dot = document.createElement("span");
      dot.className = "activity-dot";
      dot.setAttribute("aria-hidden", "true");
      const copy = document.createElement("div");
      copy.className = "activity-copy";
      const title = document.createElement("strong");
      title.textContent = eventTitle(event);
      const detail = document.createElement("span");
      detail.textContent = eventDetail(event);
      const time = document.createElement("time");
      time.dateTime = event.at;
      time.textContent = formatTime(event.at);
      copy.append(title, detail, time);
      item.append(dot, copy);
      dom.activityList.append(item);
    }
  }

  function eventTitle(event) {
    const labels = {
      mission_created: "Mission created",
      criterion_added: "Criterion added",
      criterion_reset: "Criterion reset",
      criterion_checked: event.exit_code === 0 ? "Check passed" : "Check failed",
      criterion_satisfied: "Evidence recorded",
      note_added: "Note added",
      mission_blocked: "Mission blocked",
      mission_resumed: "Mission resumed",
      mission_canceled: "Mission canceled",
      mission_reopened: "Mission reopened",
      mission_completed: "Mission completed"
    };
    return labels[event.type] || event.type.replaceAll("_", " ");
  }

  function eventDetail(event) {
    const subject = event.reason || event.summary || event.criterion_id || event.command || "State recorded";
    return `${subject} · ${event.actor || "unknown"}`;
  }

  function formatTime(value) {
    const date = new Date(value);
    return new Intl.DateTimeFormat(undefined, { month: "short", day: "numeric", hour: "numeric", minute: "2-digit" }).format(date);
  }

  function parseCommand(input) {
    const argumentsList = [];
    let current = "";
    let quote = null;
    let escaped = false;
    let started = false;
    for (const character of input.trim()) {
      if (escaped) {
        current += character;
        escaped = false;
        started = true;
      } else if (character === "\\" && quote !== "'") {
        escaped = true;
        started = true;
      } else if (quote) {
        if (character === quote) quote = null;
        else current += character;
        started = true;
      } else if (character === '"' || character === "'") {
        quote = character;
        started = true;
      } else if (/\s/.test(character)) {
        if (started) {
          argumentsList.push(current);
          current = "";
          started = false;
        }
      } else {
        current += character;
        started = true;
      }
    }
    if (escaped || quote) throw new Error("Command has an unfinished quote or escape");
    if (started) argumentsList.push(current);
    if (!argumentsList.length) throw new Error("Command is required");
    return argumentsList;
  }

  async function submitAction(event) {
    event.preventDefault();
    const data = new FormData(dom.form);
    const actor = dom.actorInput.value.trim();
    if (!actor) {
      showFormError("Recorded as is required", dom.actorInput);
      dom.actorInput.focus();
      return;
    }
    const payload = { action: modalState.action, actor, ...modalState.context };
    for (const [key, value] of data.entries()) payload[key] = value.trim();
    try {
      if (payload.action === "create") {
        payload.criteria = payload.criteria.split(/\r?\n/).map((value) => value.trim()).filter(Boolean);
      }
      if (payload.action === "check") payload.command = parseCommand(payload.command);
      const required = dom.formFields.querySelectorAll("[required]");
      const missing = [...required].find((field) => !field.value.trim());
      if (missing) {
        missing.focus();
        const error = new Error(`${missing.closest("label").querySelector("span").textContent.replace(" (required)", "")} is required`);
        error.field = missing;
        throw error;
      }
      dom.formError.hidden = true;
      dom.modalSubmit.disabled = true;
      dom.modalSubmit.classList.add("is-loading");
      dom.modalSubmit.textContent = "Working…";
      localStorage.setItem("orcaActor", actor);
      const result = await api("/api/action", {
        method: "POST",
        headers: { "Content-Type": "application/json", "X-Orca-Token": sessionToken },
        body: JSON.stringify(payload)
      });
      if (result.mission) state.selectedId = result.mission.id;
      const label = actionDefinitions[payload.action].submit;
      closeModal();
      showToast(`${label} — recorded`);
      await loadState();
    } catch (error) {
      showFormError(error.message, error.field);
      dom.modalSubmit.disabled = false;
      dom.modalSubmit.classList.remove("is-loading");
      dom.modalSubmit.textContent = actionDefinitions[modalState.action].submit;
    }
  }

  function showFormError(message, field = null) {
    dom.formError.textContent = message;
    dom.formError.hidden = false;
    dom.form.querySelectorAll('[aria-describedby="form-error"]').forEach((item) => item.removeAttribute("aria-describedby"));
    if (field) field.setAttribute("aria-describedby", "form-error");
  }

  function trapModalFocus(event) {
    if (event.key === "Escape") {
      closeModal();
      return;
    }
    if (event.key !== "Tab") return;
    const focusable = [...dom.modal.querySelectorAll('button:not(:disabled), input:not(:disabled), textarea:not(:disabled), [href]')];
    if (!focusable.length) return;
    const first = focusable[0];
    const last = focusable[focusable.length - 1];
    if (event.shiftKey && document.activeElement === first) {
      event.preventDefault();
      last.focus();
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault();
      first.focus();
    }
  }

  document.querySelectorAll(".new-mission-button, .empty-create-button, .empty-primary-button").forEach((button) => {
    button.addEventListener("click", () => openAction("create", {}, button));
  });
  dom.refresh.addEventListener("click", () => loadState({ quiet: true }));
  dom.complete.addEventListener("click", () => openAction("complete", {}, dom.complete));
  dom.addCriterion.addEventListener("click", () => openAction("add", {}, dom.addCriterion));
  dom.addNote.addEventListener("click", () => openAction("note", {}, dom.addNote));
  dom.block.addEventListener("click", () => openAction("block", {}, dom.block));
  dom.resume.addEventListener("click", () => openAction("resume", {}, dom.resume));
  dom.cancel.addEventListener("click", () => openAction("cancel", {}, dom.cancel));
  dom.reopen.addEventListener("click", () => openAction("reopen", { mission_id: state.current.id }, dom.reopen));
  document.querySelector(".modal-close").addEventListener("click", closeModal);
  document.querySelector(".modal-cancel").addEventListener("click", closeModal);
  dom.modalBackdrop.addEventListener("mousedown", (event) => {
    if (event.target === dom.modalBackdrop) closeModal();
  });
  dom.modal.addEventListener("keydown", trapModalFocus);
  dom.form.addEventListener("submit", submitAction);

  loadState();
})();
