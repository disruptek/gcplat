
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Stackdriver Debugger
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Examines the call stack and variables of a running application without stopping or slowing it down.
## 
## 
## https://cloud.google.com/debugger
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "clouddebugger"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouddebuggerControllerDebuggeesRegister_588710 = ref object of OpenApiRestCall_588441
proc url_ClouddebuggerControllerDebuggeesRegister_588712(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClouddebuggerControllerDebuggeesRegister_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers the debuggee with the controller service.
  ## 
  ## All agents attached to the same application must call this method with
  ## exactly the same request content to get back the same stable `debuggee_id`.
  ## Agents should call this method again whenever `google.rpc.Code.NOT_FOUND`
  ## is returned from any controller method.
  ## 
  ## This protocol allows the controller service to disable debuggees, recover
  ## from data loss, or change the `debuggee_id` format. Agents must handle
  ## `debuggee_id` value changing upon re-registration.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("quotaUser")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "quotaUser", valid_588826
  var valid_588840 = query.getOrDefault("alt")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = newJString("json"))
  if valid_588840 != nil:
    section.add "alt", valid_588840
  var valid_588841 = query.getOrDefault("oauth_token")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "oauth_token", valid_588841
  var valid_588842 = query.getOrDefault("callback")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "callback", valid_588842
  var valid_588843 = query.getOrDefault("access_token")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "access_token", valid_588843
  var valid_588844 = query.getOrDefault("uploadType")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "uploadType", valid_588844
  var valid_588845 = query.getOrDefault("key")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "key", valid_588845
  var valid_588846 = query.getOrDefault("$.xgafv")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = newJString("1"))
  if valid_588846 != nil:
    section.add "$.xgafv", valid_588846
  var valid_588847 = query.getOrDefault("prettyPrint")
  valid_588847 = validateParameter(valid_588847, JBool, required = false,
                                 default = newJBool(true))
  if valid_588847 != nil:
    section.add "prettyPrint", valid_588847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_588871: Call_ClouddebuggerControllerDebuggeesRegister_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Registers the debuggee with the controller service.
  ## 
  ## All agents attached to the same application must call this method with
  ## exactly the same request content to get back the same stable `debuggee_id`.
  ## Agents should call this method again whenever `google.rpc.Code.NOT_FOUND`
  ## is returned from any controller method.
  ## 
  ## This protocol allows the controller service to disable debuggees, recover
  ## from data loss, or change the `debuggee_id` format. Agents must handle
  ## `debuggee_id` value changing upon re-registration.
  ## 
  let valid = call_588871.validator(path, query, header, formData, body)
  let scheme = call_588871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588871.url(scheme.get, call_588871.host, call_588871.base,
                         call_588871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588871, url, valid)

proc call*(call_588942: Call_ClouddebuggerControllerDebuggeesRegister_588710;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## clouddebuggerControllerDebuggeesRegister
  ## Registers the debuggee with the controller service.
  ## 
  ## All agents attached to the same application must call this method with
  ## exactly the same request content to get back the same stable `debuggee_id`.
  ## Agents should call this method again whenever `google.rpc.Code.NOT_FOUND`
  ## is returned from any controller method.
  ## 
  ## This protocol allows the controller service to disable debuggees, recover
  ## from data loss, or change the `debuggee_id` format. Agents must handle
  ## `debuggee_id` value changing upon re-registration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588943 = newJObject()
  var body_588945 = newJObject()
  add(query_588943, "upload_protocol", newJString(uploadProtocol))
  add(query_588943, "fields", newJString(fields))
  add(query_588943, "quotaUser", newJString(quotaUser))
  add(query_588943, "alt", newJString(alt))
  add(query_588943, "oauth_token", newJString(oauthToken))
  add(query_588943, "callback", newJString(callback))
  add(query_588943, "access_token", newJString(accessToken))
  add(query_588943, "uploadType", newJString(uploadType))
  add(query_588943, "key", newJString(key))
  add(query_588943, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588945 = body
  add(query_588943, "prettyPrint", newJBool(prettyPrint))
  result = call_588942.call(nil, query_588943, nil, nil, body_588945)

var clouddebuggerControllerDebuggeesRegister* = Call_ClouddebuggerControllerDebuggeesRegister_588710(
    name: "clouddebuggerControllerDebuggeesRegister", meth: HttpMethod.HttpPost,
    host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/register",
    validator: validate_ClouddebuggerControllerDebuggeesRegister_588711,
    base: "/", url: url_ClouddebuggerControllerDebuggeesRegister_588712,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerControllerDebuggeesBreakpointsList_588984 = ref object of OpenApiRestCall_588441
proc url_ClouddebuggerControllerDebuggeesBreakpointsList_588986(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/controller/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouddebuggerControllerDebuggeesBreakpointsList_588985(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the list of all active breakpoints for the debuggee.
  ## 
  ## The breakpoint specification (`location`, `condition`, and `expressions`
  ## fields) is semantically immutable, although the field values may
  ## change. For example, an agent may update the location line number
  ## to reflect the actual line where the breakpoint was set, but this
  ## doesn't change the breakpoint semantics.
  ## 
  ## This means that an agent does not need to check if a breakpoint has changed
  ## when it encounters the same breakpoint on a successive call.
  ## Moreover, an agent should remember the breakpoints that are completed
  ## until the controller removes them from the active list to avoid
  ## setting those breakpoints again.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   debuggeeId: JString (required)
  ##             : Identifies the debuggee.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `debuggeeId` field"
  var valid_589001 = path.getOrDefault("debuggeeId")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "debuggeeId", valid_589001
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   successOnTimeout: JBool
  ##                   : If set to `true` (recommended), returns `google.rpc.Code.OK` status and
  ## sets the `wait_expired` response field to `true` when the server-selected
  ## timeout has expired.
  ## 
  ## If set to `false` (deprecated), returns `google.rpc.Code.ABORTED` status
  ## when the server-selected timeout has expired.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   waitToken: JString
  ##            : A token that, if specified, blocks the method call until the list
  ## of active breakpoints has changed, or a server-selected timeout has
  ## expired. The value should be set from the `next_wait_token` field in
  ## the last response. The initial value should be set to `"init"`.
  section = newJObject()
  var valid_589002 = query.getOrDefault("upload_protocol")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "upload_protocol", valid_589002
  var valid_589003 = query.getOrDefault("fields")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "fields", valid_589003
  var valid_589004 = query.getOrDefault("quotaUser")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "quotaUser", valid_589004
  var valid_589005 = query.getOrDefault("alt")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("json"))
  if valid_589005 != nil:
    section.add "alt", valid_589005
  var valid_589006 = query.getOrDefault("oauth_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "oauth_token", valid_589006
  var valid_589007 = query.getOrDefault("callback")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "callback", valid_589007
  var valid_589008 = query.getOrDefault("access_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "access_token", valid_589008
  var valid_589009 = query.getOrDefault("uploadType")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "uploadType", valid_589009
  var valid_589010 = query.getOrDefault("key")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "key", valid_589010
  var valid_589011 = query.getOrDefault("successOnTimeout")
  valid_589011 = validateParameter(valid_589011, JBool, required = false, default = nil)
  if valid_589011 != nil:
    section.add "successOnTimeout", valid_589011
  var valid_589012 = query.getOrDefault("$.xgafv")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("1"))
  if valid_589012 != nil:
    section.add "$.xgafv", valid_589012
  var valid_589013 = query.getOrDefault("prettyPrint")
  valid_589013 = validateParameter(valid_589013, JBool, required = false,
                                 default = newJBool(true))
  if valid_589013 != nil:
    section.add "prettyPrint", valid_589013
  var valid_589014 = query.getOrDefault("waitToken")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "waitToken", valid_589014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589015: Call_ClouddebuggerControllerDebuggeesBreakpointsList_588984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of all active breakpoints for the debuggee.
  ## 
  ## The breakpoint specification (`location`, `condition`, and `expressions`
  ## fields) is semantically immutable, although the field values may
  ## change. For example, an agent may update the location line number
  ## to reflect the actual line where the breakpoint was set, but this
  ## doesn't change the breakpoint semantics.
  ## 
  ## This means that an agent does not need to check if a breakpoint has changed
  ## when it encounters the same breakpoint on a successive call.
  ## Moreover, an agent should remember the breakpoints that are completed
  ## until the controller removes them from the active list to avoid
  ## setting those breakpoints again.
  ## 
  let valid = call_589015.validator(path, query, header, formData, body)
  let scheme = call_589015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589015.url(scheme.get, call_589015.host, call_589015.base,
                         call_589015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589015, url, valid)

proc call*(call_589016: Call_ClouddebuggerControllerDebuggeesBreakpointsList_588984;
          debuggeeId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; successOnTimeout: bool = false; Xgafv: string = "1";
          prettyPrint: bool = true; waitToken: string = ""): Recallable =
  ## clouddebuggerControllerDebuggeesBreakpointsList
  ## Returns the list of all active breakpoints for the debuggee.
  ## 
  ## The breakpoint specification (`location`, `condition`, and `expressions`
  ## fields) is semantically immutable, although the field values may
  ## change. For example, an agent may update the location line number
  ## to reflect the actual line where the breakpoint was set, but this
  ## doesn't change the breakpoint semantics.
  ## 
  ## This means that an agent does not need to check if a breakpoint has changed
  ## when it encounters the same breakpoint on a successive call.
  ## Moreover, an agent should remember the breakpoints that are completed
  ## until the controller removes them from the active list to avoid
  ## setting those breakpoints again.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   debuggeeId: string (required)
  ##             : Identifies the debuggee.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   successOnTimeout: bool
  ##                   : If set to `true` (recommended), returns `google.rpc.Code.OK` status and
  ## sets the `wait_expired` response field to `true` when the server-selected
  ## timeout has expired.
  ## 
  ## If set to `false` (deprecated), returns `google.rpc.Code.ABORTED` status
  ## when the server-selected timeout has expired.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   waitToken: string
  ##            : A token that, if specified, blocks the method call until the list
  ## of active breakpoints has changed, or a server-selected timeout has
  ## expired. The value should be set from the `next_wait_token` field in
  ## the last response. The initial value should be set to `"init"`.
  var path_589017 = newJObject()
  var query_589018 = newJObject()
  add(query_589018, "upload_protocol", newJString(uploadProtocol))
  add(path_589017, "debuggeeId", newJString(debuggeeId))
  add(query_589018, "fields", newJString(fields))
  add(query_589018, "quotaUser", newJString(quotaUser))
  add(query_589018, "alt", newJString(alt))
  add(query_589018, "oauth_token", newJString(oauthToken))
  add(query_589018, "callback", newJString(callback))
  add(query_589018, "access_token", newJString(accessToken))
  add(query_589018, "uploadType", newJString(uploadType))
  add(query_589018, "key", newJString(key))
  add(query_589018, "successOnTimeout", newJBool(successOnTimeout))
  add(query_589018, "$.xgafv", newJString(Xgafv))
  add(query_589018, "prettyPrint", newJBool(prettyPrint))
  add(query_589018, "waitToken", newJString(waitToken))
  result = call_589016.call(path_589017, query_589018, nil, nil, nil)

var clouddebuggerControllerDebuggeesBreakpointsList* = Call_ClouddebuggerControllerDebuggeesBreakpointsList_588984(
    name: "clouddebuggerControllerDebuggeesBreakpointsList",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/{debuggeeId}/breakpoints",
    validator: validate_ClouddebuggerControllerDebuggeesBreakpointsList_588985,
    base: "/", url: url_ClouddebuggerControllerDebuggeesBreakpointsList_588986,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_589019 = ref object of OpenApiRestCall_588441
proc url_ClouddebuggerControllerDebuggeesBreakpointsUpdate_589021(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/controller/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouddebuggerControllerDebuggeesBreakpointsUpdate_589020(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the breakpoint state or mutable fields.
  ## The entire Breakpoint message must be sent back to the controller service.
  ## 
  ## Updates to active breakpoint fields are only allowed if the new value
  ## does not change the breakpoint specification. Updates to the `location`,
  ## `condition` and `expressions` fields should not alter the breakpoint
  ## semantics. These may only make changes such as canonicalizing a value
  ## or snapping the location to the correct line of code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   debuggeeId: JString (required)
  ##             : Identifies the debuggee being debugged.
  ##   id: JString (required)
  ##     : Breakpoint identifier, unique in the scope of the debuggee.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `debuggeeId` field"
  var valid_589022 = path.getOrDefault("debuggeeId")
  valid_589022 = validateParameter(valid_589022, JString, required = true,
                                 default = nil)
  if valid_589022 != nil:
    section.add "debuggeeId", valid_589022
  var valid_589023 = path.getOrDefault("id")
  valid_589023 = validateParameter(valid_589023, JString, required = true,
                                 default = nil)
  if valid_589023 != nil:
    section.add "id", valid_589023
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589024 = query.getOrDefault("upload_protocol")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "upload_protocol", valid_589024
  var valid_589025 = query.getOrDefault("fields")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "fields", valid_589025
  var valid_589026 = query.getOrDefault("quotaUser")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "quotaUser", valid_589026
  var valid_589027 = query.getOrDefault("alt")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = newJString("json"))
  if valid_589027 != nil:
    section.add "alt", valid_589027
  var valid_589028 = query.getOrDefault("oauth_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "oauth_token", valid_589028
  var valid_589029 = query.getOrDefault("callback")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "callback", valid_589029
  var valid_589030 = query.getOrDefault("access_token")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "access_token", valid_589030
  var valid_589031 = query.getOrDefault("uploadType")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "uploadType", valid_589031
  var valid_589032 = query.getOrDefault("key")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "key", valid_589032
  var valid_589033 = query.getOrDefault("$.xgafv")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("1"))
  if valid_589033 != nil:
    section.add "$.xgafv", valid_589033
  var valid_589034 = query.getOrDefault("prettyPrint")
  valid_589034 = validateParameter(valid_589034, JBool, required = false,
                                 default = newJBool(true))
  if valid_589034 != nil:
    section.add "prettyPrint", valid_589034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589036: Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_589019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the breakpoint state or mutable fields.
  ## The entire Breakpoint message must be sent back to the controller service.
  ## 
  ## Updates to active breakpoint fields are only allowed if the new value
  ## does not change the breakpoint specification. Updates to the `location`,
  ## `condition` and `expressions` fields should not alter the breakpoint
  ## semantics. These may only make changes such as canonicalizing a value
  ## or snapping the location to the correct line of code.
  ## 
  let valid = call_589036.validator(path, query, header, formData, body)
  let scheme = call_589036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589036.url(scheme.get, call_589036.host, call_589036.base,
                         call_589036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589036, url, valid)

proc call*(call_589037: Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_589019;
          debuggeeId: string; id: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## clouddebuggerControllerDebuggeesBreakpointsUpdate
  ## Updates the breakpoint state or mutable fields.
  ## The entire Breakpoint message must be sent back to the controller service.
  ## 
  ## Updates to active breakpoint fields are only allowed if the new value
  ## does not change the breakpoint specification. Updates to the `location`,
  ## `condition` and `expressions` fields should not alter the breakpoint
  ## semantics. These may only make changes such as canonicalizing a value
  ## or snapping the location to the correct line of code.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   debuggeeId: string (required)
  ##             : Identifies the debuggee being debugged.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   id: string (required)
  ##     : Breakpoint identifier, unique in the scope of the debuggee.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589038 = newJObject()
  var query_589039 = newJObject()
  var body_589040 = newJObject()
  add(query_589039, "upload_protocol", newJString(uploadProtocol))
  add(path_589038, "debuggeeId", newJString(debuggeeId))
  add(query_589039, "fields", newJString(fields))
  add(query_589039, "quotaUser", newJString(quotaUser))
  add(query_589039, "alt", newJString(alt))
  add(query_589039, "oauth_token", newJString(oauthToken))
  add(query_589039, "callback", newJString(callback))
  add(query_589039, "access_token", newJString(accessToken))
  add(query_589039, "uploadType", newJString(uploadType))
  add(path_589038, "id", newJString(id))
  add(query_589039, "key", newJString(key))
  add(query_589039, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589040 = body
  add(query_589039, "prettyPrint", newJBool(prettyPrint))
  result = call_589037.call(path_589038, query_589039, nil, nil, body_589040)

var clouddebuggerControllerDebuggeesBreakpointsUpdate* = Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_589019(
    name: "clouddebuggerControllerDebuggeesBreakpointsUpdate",
    meth: HttpMethod.HttpPut, host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/{debuggeeId}/breakpoints/{id}",
    validator: validate_ClouddebuggerControllerDebuggeesBreakpointsUpdate_589020,
    base: "/", url: url_ClouddebuggerControllerDebuggeesBreakpointsUpdate_589021,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesList_589041 = ref object of OpenApiRestCall_588441
proc url_ClouddebuggerDebuggerDebuggeesList_589043(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClouddebuggerDebuggerDebuggeesList_589042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the debuggees that the user has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   includeInactive: JBool
  ##                  : When set to `true`, the result includes all debuggees. Otherwise, the
  ## result includes only debuggees that are active.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   project: JString
  ##          : Project number of a Google Cloud project whose debuggees to list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clientVersion: JString
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_589044 = query.getOrDefault("upload_protocol")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "upload_protocol", valid_589044
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("includeInactive")
  valid_589048 = validateParameter(valid_589048, JBool, required = false, default = nil)
  if valid_589048 != nil:
    section.add "includeInactive", valid_589048
  var valid_589049 = query.getOrDefault("oauth_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "oauth_token", valid_589049
  var valid_589050 = query.getOrDefault("callback")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "callback", valid_589050
  var valid_589051 = query.getOrDefault("access_token")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "access_token", valid_589051
  var valid_589052 = query.getOrDefault("uploadType")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "uploadType", valid_589052
  var valid_589053 = query.getOrDefault("key")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "key", valid_589053
  var valid_589054 = query.getOrDefault("$.xgafv")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("1"))
  if valid_589054 != nil:
    section.add "$.xgafv", valid_589054
  var valid_589055 = query.getOrDefault("project")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "project", valid_589055
  var valid_589056 = query.getOrDefault("prettyPrint")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(true))
  if valid_589056 != nil:
    section.add "prettyPrint", valid_589056
  var valid_589057 = query.getOrDefault("clientVersion")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "clientVersion", valid_589057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589058: Call_ClouddebuggerDebuggerDebuggeesList_589041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the debuggees that the user has access to.
  ## 
  let valid = call_589058.validator(path, query, header, formData, body)
  let scheme = call_589058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589058.url(scheme.get, call_589058.host, call_589058.base,
                         call_589058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589058, url, valid)

proc call*(call_589059: Call_ClouddebuggerDebuggerDebuggeesList_589041;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; includeInactive: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; project: string = "";
          prettyPrint: bool = true; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesList
  ## Lists all the debuggees that the user has access to.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   includeInactive: bool
  ##                  : When set to `true`, the result includes all debuggees. Otherwise, the
  ## result includes only debuggees that are active.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   project: string
  ##          : Project number of a Google Cloud project whose debuggees to list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clientVersion: string
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var query_589060 = newJObject()
  add(query_589060, "upload_protocol", newJString(uploadProtocol))
  add(query_589060, "fields", newJString(fields))
  add(query_589060, "quotaUser", newJString(quotaUser))
  add(query_589060, "alt", newJString(alt))
  add(query_589060, "includeInactive", newJBool(includeInactive))
  add(query_589060, "oauth_token", newJString(oauthToken))
  add(query_589060, "callback", newJString(callback))
  add(query_589060, "access_token", newJString(accessToken))
  add(query_589060, "uploadType", newJString(uploadType))
  add(query_589060, "key", newJString(key))
  add(query_589060, "$.xgafv", newJString(Xgafv))
  add(query_589060, "project", newJString(project))
  add(query_589060, "prettyPrint", newJBool(prettyPrint))
  add(query_589060, "clientVersion", newJString(clientVersion))
  result = call_589059.call(nil, query_589060, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesList* = Call_ClouddebuggerDebuggerDebuggeesList_589041(
    name: "clouddebuggerDebuggerDebuggeesList", meth: HttpMethod.HttpGet,
    host: "clouddebugger.googleapis.com", route: "/v2/debugger/debuggees",
    validator: validate_ClouddebuggerDebuggerDebuggeesList_589042, base: "/",
    url: url_ClouddebuggerDebuggerDebuggeesList_589043, schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_589061 = ref object of OpenApiRestCall_588441
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsList_589063(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/debugger/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsList_589062(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all breakpoints for the debuggee.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   debuggeeId: JString (required)
  ##             : ID of the debuggee whose breakpoints to list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `debuggeeId` field"
  var valid_589064 = path.getOrDefault("debuggeeId")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "debuggeeId", valid_589064
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeAllUsers: JBool
  ##                  : When set to `true`, the response includes the list of breakpoints set by
  ## any user. Otherwise, it includes only breakpoints set by the caller.
  ##   alt: JString
  ##      : Data format for response.
  ##   includeInactive: JBool
  ##                  : When set to `true`, the response includes active and inactive
  ## breakpoints. Otherwise, it includes only active breakpoints.
  ##   action.value: JString
  ##               : Only breakpoints with the specified action will pass the filter.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   stripResults: JBool
  ##               : This field is deprecated. The following fields are always stripped out of
  ## the result: `stack_frames`, `evaluated_expressions` and `variable_table`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clientVersion: JString
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  ##   waitToken: JString
  ##            : A wait token that, if specified, blocks the call until the breakpoints
  ## list has changed, or a server selected timeout has expired.  The value
  ## should be set from the last response. The error code
  ## `google.rpc.Code.ABORTED` (RPC) is returned on wait timeout, which
  ## should be called again with the same `wait_token`.
  section = newJObject()
  var valid_589065 = query.getOrDefault("upload_protocol")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "upload_protocol", valid_589065
  var valid_589066 = query.getOrDefault("fields")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "fields", valid_589066
  var valid_589067 = query.getOrDefault("quotaUser")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "quotaUser", valid_589067
  var valid_589068 = query.getOrDefault("includeAllUsers")
  valid_589068 = validateParameter(valid_589068, JBool, required = false, default = nil)
  if valid_589068 != nil:
    section.add "includeAllUsers", valid_589068
  var valid_589069 = query.getOrDefault("alt")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = newJString("json"))
  if valid_589069 != nil:
    section.add "alt", valid_589069
  var valid_589070 = query.getOrDefault("includeInactive")
  valid_589070 = validateParameter(valid_589070, JBool, required = false, default = nil)
  if valid_589070 != nil:
    section.add "includeInactive", valid_589070
  var valid_589071 = query.getOrDefault("action.value")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = newJString("CAPTURE"))
  if valid_589071 != nil:
    section.add "action.value", valid_589071
  var valid_589072 = query.getOrDefault("oauth_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "oauth_token", valid_589072
  var valid_589073 = query.getOrDefault("callback")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "callback", valid_589073
  var valid_589074 = query.getOrDefault("access_token")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "access_token", valid_589074
  var valid_589075 = query.getOrDefault("uploadType")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "uploadType", valid_589075
  var valid_589076 = query.getOrDefault("stripResults")
  valid_589076 = validateParameter(valid_589076, JBool, required = false, default = nil)
  if valid_589076 != nil:
    section.add "stripResults", valid_589076
  var valid_589077 = query.getOrDefault("key")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "key", valid_589077
  var valid_589078 = query.getOrDefault("$.xgafv")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = newJString("1"))
  if valid_589078 != nil:
    section.add "$.xgafv", valid_589078
  var valid_589079 = query.getOrDefault("prettyPrint")
  valid_589079 = validateParameter(valid_589079, JBool, required = false,
                                 default = newJBool(true))
  if valid_589079 != nil:
    section.add "prettyPrint", valid_589079
  var valid_589080 = query.getOrDefault("clientVersion")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "clientVersion", valid_589080
  var valid_589081 = query.getOrDefault("waitToken")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "waitToken", valid_589081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589082: Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_589061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all breakpoints for the debuggee.
  ## 
  let valid = call_589082.validator(path, query, header, formData, body)
  let scheme = call_589082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589082.url(scheme.get, call_589082.host, call_589082.base,
                         call_589082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589082, url, valid)

proc call*(call_589083: Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_589061;
          debuggeeId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeAllUsers: bool = false; alt: string = "json";
          includeInactive: bool = false; actionValue: string = "CAPTURE";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; stripResults: bool = false; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; clientVersion: string = "";
          waitToken: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsList
  ## Lists all breakpoints for the debuggee.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   debuggeeId: string (required)
  ##             : ID of the debuggee whose breakpoints to list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeAllUsers: bool
  ##                  : When set to `true`, the response includes the list of breakpoints set by
  ## any user. Otherwise, it includes only breakpoints set by the caller.
  ##   alt: string
  ##      : Data format for response.
  ##   includeInactive: bool
  ##                  : When set to `true`, the response includes active and inactive
  ## breakpoints. Otherwise, it includes only active breakpoints.
  ##   actionValue: string
  ##              : Only breakpoints with the specified action will pass the filter.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   stripResults: bool
  ##               : This field is deprecated. The following fields are always stripped out of
  ## the result: `stack_frames`, `evaluated_expressions` and `variable_table`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clientVersion: string
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  ##   waitToken: string
  ##            : A wait token that, if specified, blocks the call until the breakpoints
  ## list has changed, or a server selected timeout has expired.  The value
  ## should be set from the last response. The error code
  ## `google.rpc.Code.ABORTED` (RPC) is returned on wait timeout, which
  ## should be called again with the same `wait_token`.
  var path_589084 = newJObject()
  var query_589085 = newJObject()
  add(query_589085, "upload_protocol", newJString(uploadProtocol))
  add(path_589084, "debuggeeId", newJString(debuggeeId))
  add(query_589085, "fields", newJString(fields))
  add(query_589085, "quotaUser", newJString(quotaUser))
  add(query_589085, "includeAllUsers", newJBool(includeAllUsers))
  add(query_589085, "alt", newJString(alt))
  add(query_589085, "includeInactive", newJBool(includeInactive))
  add(query_589085, "action.value", newJString(actionValue))
  add(query_589085, "oauth_token", newJString(oauthToken))
  add(query_589085, "callback", newJString(callback))
  add(query_589085, "access_token", newJString(accessToken))
  add(query_589085, "uploadType", newJString(uploadType))
  add(query_589085, "stripResults", newJBool(stripResults))
  add(query_589085, "key", newJString(key))
  add(query_589085, "$.xgafv", newJString(Xgafv))
  add(query_589085, "prettyPrint", newJBool(prettyPrint))
  add(query_589085, "clientVersion", newJString(clientVersion))
  add(query_589085, "waitToken", newJString(waitToken))
  result = call_589083.call(path_589084, query_589085, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsList* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_589061(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsList",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsList_589062,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsList_589063,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_589086 = ref object of OpenApiRestCall_588441
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsSet_589088(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/debugger/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints/set")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsSet_589087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the breakpoint to the debuggee.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   debuggeeId: JString (required)
  ##             : ID of the debuggee where the breakpoint is to be set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `debuggeeId` field"
  var valid_589089 = path.getOrDefault("debuggeeId")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "debuggeeId", valid_589089
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clientVersion: JString
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_589090 = query.getOrDefault("upload_protocol")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "upload_protocol", valid_589090
  var valid_589091 = query.getOrDefault("fields")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "fields", valid_589091
  var valid_589092 = query.getOrDefault("quotaUser")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "quotaUser", valid_589092
  var valid_589093 = query.getOrDefault("alt")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = newJString("json"))
  if valid_589093 != nil:
    section.add "alt", valid_589093
  var valid_589094 = query.getOrDefault("oauth_token")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "oauth_token", valid_589094
  var valid_589095 = query.getOrDefault("callback")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "callback", valid_589095
  var valid_589096 = query.getOrDefault("access_token")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "access_token", valid_589096
  var valid_589097 = query.getOrDefault("uploadType")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "uploadType", valid_589097
  var valid_589098 = query.getOrDefault("key")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "key", valid_589098
  var valid_589099 = query.getOrDefault("$.xgafv")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = newJString("1"))
  if valid_589099 != nil:
    section.add "$.xgafv", valid_589099
  var valid_589100 = query.getOrDefault("prettyPrint")
  valid_589100 = validateParameter(valid_589100, JBool, required = false,
                                 default = newJBool(true))
  if valid_589100 != nil:
    section.add "prettyPrint", valid_589100
  var valid_589101 = query.getOrDefault("clientVersion")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "clientVersion", valid_589101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589103: Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_589086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the breakpoint to the debuggee.
  ## 
  let valid = call_589103.validator(path, query, header, formData, body)
  let scheme = call_589103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589103.url(scheme.get, call_589103.host, call_589103.base,
                         call_589103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589103, url, valid)

proc call*(call_589104: Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_589086;
          debuggeeId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsSet
  ## Sets the breakpoint to the debuggee.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   debuggeeId: string (required)
  ##             : ID of the debuggee where the breakpoint is to be set.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clientVersion: string
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var path_589105 = newJObject()
  var query_589106 = newJObject()
  var body_589107 = newJObject()
  add(query_589106, "upload_protocol", newJString(uploadProtocol))
  add(path_589105, "debuggeeId", newJString(debuggeeId))
  add(query_589106, "fields", newJString(fields))
  add(query_589106, "quotaUser", newJString(quotaUser))
  add(query_589106, "alt", newJString(alt))
  add(query_589106, "oauth_token", newJString(oauthToken))
  add(query_589106, "callback", newJString(callback))
  add(query_589106, "access_token", newJString(accessToken))
  add(query_589106, "uploadType", newJString(uploadType))
  add(query_589106, "key", newJString(key))
  add(query_589106, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589107 = body
  add(query_589106, "prettyPrint", newJBool(prettyPrint))
  add(query_589106, "clientVersion", newJString(clientVersion))
  result = call_589104.call(path_589105, query_589106, nil, nil, body_589107)

var clouddebuggerDebuggerDebuggeesBreakpointsSet* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_589086(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsSet",
    meth: HttpMethod.HttpPost, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/set",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsSet_589087,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsSet_589088,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_589108 = ref object of OpenApiRestCall_588441
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsGet_589110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  assert "breakpointId" in path, "`breakpointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/debugger/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints/"),
               (kind: VariableSegment, value: "breakpointId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsGet_589109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets breakpoint information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   debuggeeId: JString (required)
  ##             : ID of the debuggee whose breakpoint to get.
  ##   breakpointId: JString (required)
  ##               : ID of the breakpoint to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `debuggeeId` field"
  var valid_589111 = path.getOrDefault("debuggeeId")
  valid_589111 = validateParameter(valid_589111, JString, required = true,
                                 default = nil)
  if valid_589111 != nil:
    section.add "debuggeeId", valid_589111
  var valid_589112 = path.getOrDefault("breakpointId")
  valid_589112 = validateParameter(valid_589112, JString, required = true,
                                 default = nil)
  if valid_589112 != nil:
    section.add "breakpointId", valid_589112
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clientVersion: JString
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_589113 = query.getOrDefault("upload_protocol")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "upload_protocol", valid_589113
  var valid_589114 = query.getOrDefault("fields")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "fields", valid_589114
  var valid_589115 = query.getOrDefault("quotaUser")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "quotaUser", valid_589115
  var valid_589116 = query.getOrDefault("alt")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = newJString("json"))
  if valid_589116 != nil:
    section.add "alt", valid_589116
  var valid_589117 = query.getOrDefault("oauth_token")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "oauth_token", valid_589117
  var valid_589118 = query.getOrDefault("callback")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "callback", valid_589118
  var valid_589119 = query.getOrDefault("access_token")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "access_token", valid_589119
  var valid_589120 = query.getOrDefault("uploadType")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "uploadType", valid_589120
  var valid_589121 = query.getOrDefault("key")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "key", valid_589121
  var valid_589122 = query.getOrDefault("$.xgafv")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = newJString("1"))
  if valid_589122 != nil:
    section.add "$.xgafv", valid_589122
  var valid_589123 = query.getOrDefault("prettyPrint")
  valid_589123 = validateParameter(valid_589123, JBool, required = false,
                                 default = newJBool(true))
  if valid_589123 != nil:
    section.add "prettyPrint", valid_589123
  var valid_589124 = query.getOrDefault("clientVersion")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "clientVersion", valid_589124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589125: Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_589108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets breakpoint information.
  ## 
  let valid = call_589125.validator(path, query, header, formData, body)
  let scheme = call_589125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589125.url(scheme.get, call_589125.host, call_589125.base,
                         call_589125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589125, url, valid)

proc call*(call_589126: Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_589108;
          debuggeeId: string; breakpointId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsGet
  ## Gets breakpoint information.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   debuggeeId: string (required)
  ##             : ID of the debuggee whose breakpoint to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   breakpointId: string (required)
  ##               : ID of the breakpoint to get.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clientVersion: string
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var path_589127 = newJObject()
  var query_589128 = newJObject()
  add(query_589128, "upload_protocol", newJString(uploadProtocol))
  add(path_589127, "debuggeeId", newJString(debuggeeId))
  add(query_589128, "fields", newJString(fields))
  add(query_589128, "quotaUser", newJString(quotaUser))
  add(query_589128, "alt", newJString(alt))
  add(path_589127, "breakpointId", newJString(breakpointId))
  add(query_589128, "oauth_token", newJString(oauthToken))
  add(query_589128, "callback", newJString(callback))
  add(query_589128, "access_token", newJString(accessToken))
  add(query_589128, "uploadType", newJString(uploadType))
  add(query_589128, "key", newJString(key))
  add(query_589128, "$.xgafv", newJString(Xgafv))
  add(query_589128, "prettyPrint", newJBool(prettyPrint))
  add(query_589128, "clientVersion", newJString(clientVersion))
  result = call_589126.call(path_589127, query_589128, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsGet* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_589108(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsGet",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/{breakpointId}",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsGet_589109,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsGet_589110,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_589129 = ref object of OpenApiRestCall_588441
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_589131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "debuggeeId" in path, "`debuggeeId` is a required path parameter"
  assert "breakpointId" in path, "`breakpointId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/debugger/debuggees/"),
               (kind: VariableSegment, value: "debuggeeId"),
               (kind: ConstantSegment, value: "/breakpoints/"),
               (kind: VariableSegment, value: "breakpointId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_589130(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the breakpoint from the debuggee.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   debuggeeId: JString (required)
  ##             : ID of the debuggee whose breakpoint to delete.
  ##   breakpointId: JString (required)
  ##               : ID of the breakpoint to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `debuggeeId` field"
  var valid_589132 = path.getOrDefault("debuggeeId")
  valid_589132 = validateParameter(valid_589132, JString, required = true,
                                 default = nil)
  if valid_589132 != nil:
    section.add "debuggeeId", valid_589132
  var valid_589133 = path.getOrDefault("breakpointId")
  valid_589133 = validateParameter(valid_589133, JString, required = true,
                                 default = nil)
  if valid_589133 != nil:
    section.add "breakpointId", valid_589133
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clientVersion: JString
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_589134 = query.getOrDefault("upload_protocol")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "upload_protocol", valid_589134
  var valid_589135 = query.getOrDefault("fields")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "fields", valid_589135
  var valid_589136 = query.getOrDefault("quotaUser")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "quotaUser", valid_589136
  var valid_589137 = query.getOrDefault("alt")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = newJString("json"))
  if valid_589137 != nil:
    section.add "alt", valid_589137
  var valid_589138 = query.getOrDefault("oauth_token")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "oauth_token", valid_589138
  var valid_589139 = query.getOrDefault("callback")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "callback", valid_589139
  var valid_589140 = query.getOrDefault("access_token")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "access_token", valid_589140
  var valid_589141 = query.getOrDefault("uploadType")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "uploadType", valid_589141
  var valid_589142 = query.getOrDefault("key")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "key", valid_589142
  var valid_589143 = query.getOrDefault("$.xgafv")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = newJString("1"))
  if valid_589143 != nil:
    section.add "$.xgafv", valid_589143
  var valid_589144 = query.getOrDefault("prettyPrint")
  valid_589144 = validateParameter(valid_589144, JBool, required = false,
                                 default = newJBool(true))
  if valid_589144 != nil:
    section.add "prettyPrint", valid_589144
  var valid_589145 = query.getOrDefault("clientVersion")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "clientVersion", valid_589145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589146: Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_589129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the breakpoint from the debuggee.
  ## 
  let valid = call_589146.validator(path, query, header, formData, body)
  let scheme = call_589146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589146.url(scheme.get, call_589146.host, call_589146.base,
                         call_589146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589146, url, valid)

proc call*(call_589147: Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_589129;
          debuggeeId: string; breakpointId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsDelete
  ## Deletes the breakpoint from the debuggee.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   debuggeeId: string (required)
  ##             : ID of the debuggee whose breakpoint to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   breakpointId: string (required)
  ##               : ID of the breakpoint to delete.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clientVersion: string
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var path_589148 = newJObject()
  var query_589149 = newJObject()
  add(query_589149, "upload_protocol", newJString(uploadProtocol))
  add(path_589148, "debuggeeId", newJString(debuggeeId))
  add(query_589149, "fields", newJString(fields))
  add(query_589149, "quotaUser", newJString(quotaUser))
  add(query_589149, "alt", newJString(alt))
  add(path_589148, "breakpointId", newJString(breakpointId))
  add(query_589149, "oauth_token", newJString(oauthToken))
  add(query_589149, "callback", newJString(callback))
  add(query_589149, "access_token", newJString(accessToken))
  add(query_589149, "uploadType", newJString(uploadType))
  add(query_589149, "key", newJString(key))
  add(query_589149, "$.xgafv", newJString(Xgafv))
  add(query_589149, "prettyPrint", newJBool(prettyPrint))
  add(query_589149, "clientVersion", newJString(clientVersion))
  result = call_589147.call(path_589148, query_589149, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsDelete* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_589129(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsDelete",
    meth: HttpMethod.HttpDelete, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/{breakpointId}",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_589130,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_589131,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
