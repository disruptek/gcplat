
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouddebuggerControllerDebuggeesRegister_597677 = ref object of OpenApiRestCall_597408
proc url_ClouddebuggerControllerDebuggeesRegister_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClouddebuggerControllerDebuggeesRegister_597678(path: JsonNode;
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
  var valid_597791 = query.getOrDefault("upload_protocol")
  valid_597791 = validateParameter(valid_597791, JString, required = false,
                                 default = nil)
  if valid_597791 != nil:
    section.add "upload_protocol", valid_597791
  var valid_597792 = query.getOrDefault("fields")
  valid_597792 = validateParameter(valid_597792, JString, required = false,
                                 default = nil)
  if valid_597792 != nil:
    section.add "fields", valid_597792
  var valid_597793 = query.getOrDefault("quotaUser")
  valid_597793 = validateParameter(valid_597793, JString, required = false,
                                 default = nil)
  if valid_597793 != nil:
    section.add "quotaUser", valid_597793
  var valid_597807 = query.getOrDefault("alt")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = newJString("json"))
  if valid_597807 != nil:
    section.add "alt", valid_597807
  var valid_597808 = query.getOrDefault("oauth_token")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "oauth_token", valid_597808
  var valid_597809 = query.getOrDefault("callback")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "callback", valid_597809
  var valid_597810 = query.getOrDefault("access_token")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "access_token", valid_597810
  var valid_597811 = query.getOrDefault("uploadType")
  valid_597811 = validateParameter(valid_597811, JString, required = false,
                                 default = nil)
  if valid_597811 != nil:
    section.add "uploadType", valid_597811
  var valid_597812 = query.getOrDefault("key")
  valid_597812 = validateParameter(valid_597812, JString, required = false,
                                 default = nil)
  if valid_597812 != nil:
    section.add "key", valid_597812
  var valid_597813 = query.getOrDefault("$.xgafv")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = newJString("1"))
  if valid_597813 != nil:
    section.add "$.xgafv", valid_597813
  var valid_597814 = query.getOrDefault("prettyPrint")
  valid_597814 = validateParameter(valid_597814, JBool, required = false,
                                 default = newJBool(true))
  if valid_597814 != nil:
    section.add "prettyPrint", valid_597814
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

proc call*(call_597838: Call_ClouddebuggerControllerDebuggeesRegister_597677;
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
  let valid = call_597838.validator(path, query, header, formData, body)
  let scheme = call_597838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597838.url(scheme.get, call_597838.host, call_597838.base,
                         call_597838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597838, url, valid)

proc call*(call_597909: Call_ClouddebuggerControllerDebuggeesRegister_597677;
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
  var query_597910 = newJObject()
  var body_597912 = newJObject()
  add(query_597910, "upload_protocol", newJString(uploadProtocol))
  add(query_597910, "fields", newJString(fields))
  add(query_597910, "quotaUser", newJString(quotaUser))
  add(query_597910, "alt", newJString(alt))
  add(query_597910, "oauth_token", newJString(oauthToken))
  add(query_597910, "callback", newJString(callback))
  add(query_597910, "access_token", newJString(accessToken))
  add(query_597910, "uploadType", newJString(uploadType))
  add(query_597910, "key", newJString(key))
  add(query_597910, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597912 = body
  add(query_597910, "prettyPrint", newJBool(prettyPrint))
  result = call_597909.call(nil, query_597910, nil, nil, body_597912)

var clouddebuggerControllerDebuggeesRegister* = Call_ClouddebuggerControllerDebuggeesRegister_597677(
    name: "clouddebuggerControllerDebuggeesRegister", meth: HttpMethod.HttpPost,
    host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/register",
    validator: validate_ClouddebuggerControllerDebuggeesRegister_597678,
    base: "/", url: url_ClouddebuggerControllerDebuggeesRegister_597679,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerControllerDebuggeesBreakpointsList_597951 = ref object of OpenApiRestCall_597408
proc url_ClouddebuggerControllerDebuggeesBreakpointsList_597953(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouddebuggerControllerDebuggeesBreakpointsList_597952(
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
  var valid_597968 = path.getOrDefault("debuggeeId")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "debuggeeId", valid_597968
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
  var valid_597969 = query.getOrDefault("upload_protocol")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "upload_protocol", valid_597969
  var valid_597970 = query.getOrDefault("fields")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "fields", valid_597970
  var valid_597971 = query.getOrDefault("quotaUser")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "quotaUser", valid_597971
  var valid_597972 = query.getOrDefault("alt")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = newJString("json"))
  if valid_597972 != nil:
    section.add "alt", valid_597972
  var valid_597973 = query.getOrDefault("oauth_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "oauth_token", valid_597973
  var valid_597974 = query.getOrDefault("callback")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "callback", valid_597974
  var valid_597975 = query.getOrDefault("access_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "access_token", valid_597975
  var valid_597976 = query.getOrDefault("uploadType")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "uploadType", valid_597976
  var valid_597977 = query.getOrDefault("key")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "key", valid_597977
  var valid_597978 = query.getOrDefault("successOnTimeout")
  valid_597978 = validateParameter(valid_597978, JBool, required = false, default = nil)
  if valid_597978 != nil:
    section.add "successOnTimeout", valid_597978
  var valid_597979 = query.getOrDefault("$.xgafv")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = newJString("1"))
  if valid_597979 != nil:
    section.add "$.xgafv", valid_597979
  var valid_597980 = query.getOrDefault("prettyPrint")
  valid_597980 = validateParameter(valid_597980, JBool, required = false,
                                 default = newJBool(true))
  if valid_597980 != nil:
    section.add "prettyPrint", valid_597980
  var valid_597981 = query.getOrDefault("waitToken")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "waitToken", valid_597981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597982: Call_ClouddebuggerControllerDebuggeesBreakpointsList_597951;
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
  let valid = call_597982.validator(path, query, header, formData, body)
  let scheme = call_597982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597982.url(scheme.get, call_597982.host, call_597982.base,
                         call_597982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597982, url, valid)

proc call*(call_597983: Call_ClouddebuggerControllerDebuggeesBreakpointsList_597951;
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
  var path_597984 = newJObject()
  var query_597985 = newJObject()
  add(query_597985, "upload_protocol", newJString(uploadProtocol))
  add(path_597984, "debuggeeId", newJString(debuggeeId))
  add(query_597985, "fields", newJString(fields))
  add(query_597985, "quotaUser", newJString(quotaUser))
  add(query_597985, "alt", newJString(alt))
  add(query_597985, "oauth_token", newJString(oauthToken))
  add(query_597985, "callback", newJString(callback))
  add(query_597985, "access_token", newJString(accessToken))
  add(query_597985, "uploadType", newJString(uploadType))
  add(query_597985, "key", newJString(key))
  add(query_597985, "successOnTimeout", newJBool(successOnTimeout))
  add(query_597985, "$.xgafv", newJString(Xgafv))
  add(query_597985, "prettyPrint", newJBool(prettyPrint))
  add(query_597985, "waitToken", newJString(waitToken))
  result = call_597983.call(path_597984, query_597985, nil, nil, nil)

var clouddebuggerControllerDebuggeesBreakpointsList* = Call_ClouddebuggerControllerDebuggeesBreakpointsList_597951(
    name: "clouddebuggerControllerDebuggeesBreakpointsList",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/{debuggeeId}/breakpoints",
    validator: validate_ClouddebuggerControllerDebuggeesBreakpointsList_597952,
    base: "/", url: url_ClouddebuggerControllerDebuggeesBreakpointsList_597953,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_597986 = ref object of OpenApiRestCall_597408
proc url_ClouddebuggerControllerDebuggeesBreakpointsUpdate_597988(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouddebuggerControllerDebuggeesBreakpointsUpdate_597987(
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
  var valid_597989 = path.getOrDefault("debuggeeId")
  valid_597989 = validateParameter(valid_597989, JString, required = true,
                                 default = nil)
  if valid_597989 != nil:
    section.add "debuggeeId", valid_597989
  var valid_597990 = path.getOrDefault("id")
  valid_597990 = validateParameter(valid_597990, JString, required = true,
                                 default = nil)
  if valid_597990 != nil:
    section.add "id", valid_597990
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
  var valid_597991 = query.getOrDefault("upload_protocol")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "upload_protocol", valid_597991
  var valid_597992 = query.getOrDefault("fields")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "fields", valid_597992
  var valid_597993 = query.getOrDefault("quotaUser")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "quotaUser", valid_597993
  var valid_597994 = query.getOrDefault("alt")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = newJString("json"))
  if valid_597994 != nil:
    section.add "alt", valid_597994
  var valid_597995 = query.getOrDefault("oauth_token")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "oauth_token", valid_597995
  var valid_597996 = query.getOrDefault("callback")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "callback", valid_597996
  var valid_597997 = query.getOrDefault("access_token")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "access_token", valid_597997
  var valid_597998 = query.getOrDefault("uploadType")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "uploadType", valid_597998
  var valid_597999 = query.getOrDefault("key")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "key", valid_597999
  var valid_598000 = query.getOrDefault("$.xgafv")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = newJString("1"))
  if valid_598000 != nil:
    section.add "$.xgafv", valid_598000
  var valid_598001 = query.getOrDefault("prettyPrint")
  valid_598001 = validateParameter(valid_598001, JBool, required = false,
                                 default = newJBool(true))
  if valid_598001 != nil:
    section.add "prettyPrint", valid_598001
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

proc call*(call_598003: Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_597986;
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
  let valid = call_598003.validator(path, query, header, formData, body)
  let scheme = call_598003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598003.url(scheme.get, call_598003.host, call_598003.base,
                         call_598003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598003, url, valid)

proc call*(call_598004: Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_597986;
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
  var path_598005 = newJObject()
  var query_598006 = newJObject()
  var body_598007 = newJObject()
  add(query_598006, "upload_protocol", newJString(uploadProtocol))
  add(path_598005, "debuggeeId", newJString(debuggeeId))
  add(query_598006, "fields", newJString(fields))
  add(query_598006, "quotaUser", newJString(quotaUser))
  add(query_598006, "alt", newJString(alt))
  add(query_598006, "oauth_token", newJString(oauthToken))
  add(query_598006, "callback", newJString(callback))
  add(query_598006, "access_token", newJString(accessToken))
  add(query_598006, "uploadType", newJString(uploadType))
  add(path_598005, "id", newJString(id))
  add(query_598006, "key", newJString(key))
  add(query_598006, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598007 = body
  add(query_598006, "prettyPrint", newJBool(prettyPrint))
  result = call_598004.call(path_598005, query_598006, nil, nil, body_598007)

var clouddebuggerControllerDebuggeesBreakpointsUpdate* = Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_597986(
    name: "clouddebuggerControllerDebuggeesBreakpointsUpdate",
    meth: HttpMethod.HttpPut, host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/{debuggeeId}/breakpoints/{id}",
    validator: validate_ClouddebuggerControllerDebuggeesBreakpointsUpdate_597987,
    base: "/", url: url_ClouddebuggerControllerDebuggeesBreakpointsUpdate_597988,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesList_598008 = ref object of OpenApiRestCall_597408
proc url_ClouddebuggerDebuggerDebuggeesList_598010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClouddebuggerDebuggerDebuggeesList_598009(path: JsonNode;
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
  var valid_598011 = query.getOrDefault("upload_protocol")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "upload_protocol", valid_598011
  var valid_598012 = query.getOrDefault("fields")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "fields", valid_598012
  var valid_598013 = query.getOrDefault("quotaUser")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "quotaUser", valid_598013
  var valid_598014 = query.getOrDefault("alt")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("json"))
  if valid_598014 != nil:
    section.add "alt", valid_598014
  var valid_598015 = query.getOrDefault("includeInactive")
  valid_598015 = validateParameter(valid_598015, JBool, required = false, default = nil)
  if valid_598015 != nil:
    section.add "includeInactive", valid_598015
  var valid_598016 = query.getOrDefault("oauth_token")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "oauth_token", valid_598016
  var valid_598017 = query.getOrDefault("callback")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "callback", valid_598017
  var valid_598018 = query.getOrDefault("access_token")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "access_token", valid_598018
  var valid_598019 = query.getOrDefault("uploadType")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "uploadType", valid_598019
  var valid_598020 = query.getOrDefault("key")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "key", valid_598020
  var valid_598021 = query.getOrDefault("$.xgafv")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = newJString("1"))
  if valid_598021 != nil:
    section.add "$.xgafv", valid_598021
  var valid_598022 = query.getOrDefault("project")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "project", valid_598022
  var valid_598023 = query.getOrDefault("prettyPrint")
  valid_598023 = validateParameter(valid_598023, JBool, required = false,
                                 default = newJBool(true))
  if valid_598023 != nil:
    section.add "prettyPrint", valid_598023
  var valid_598024 = query.getOrDefault("clientVersion")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "clientVersion", valid_598024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598025: Call_ClouddebuggerDebuggerDebuggeesList_598008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the debuggees that the user has access to.
  ## 
  let valid = call_598025.validator(path, query, header, formData, body)
  let scheme = call_598025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598025.url(scheme.get, call_598025.host, call_598025.base,
                         call_598025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598025, url, valid)

proc call*(call_598026: Call_ClouddebuggerDebuggerDebuggeesList_598008;
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
  var query_598027 = newJObject()
  add(query_598027, "upload_protocol", newJString(uploadProtocol))
  add(query_598027, "fields", newJString(fields))
  add(query_598027, "quotaUser", newJString(quotaUser))
  add(query_598027, "alt", newJString(alt))
  add(query_598027, "includeInactive", newJBool(includeInactive))
  add(query_598027, "oauth_token", newJString(oauthToken))
  add(query_598027, "callback", newJString(callback))
  add(query_598027, "access_token", newJString(accessToken))
  add(query_598027, "uploadType", newJString(uploadType))
  add(query_598027, "key", newJString(key))
  add(query_598027, "$.xgafv", newJString(Xgafv))
  add(query_598027, "project", newJString(project))
  add(query_598027, "prettyPrint", newJBool(prettyPrint))
  add(query_598027, "clientVersion", newJString(clientVersion))
  result = call_598026.call(nil, query_598027, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesList* = Call_ClouddebuggerDebuggerDebuggeesList_598008(
    name: "clouddebuggerDebuggerDebuggeesList", meth: HttpMethod.HttpGet,
    host: "clouddebugger.googleapis.com", route: "/v2/debugger/debuggees",
    validator: validate_ClouddebuggerDebuggerDebuggeesList_598009, base: "/",
    url: url_ClouddebuggerDebuggerDebuggeesList_598010, schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_598028 = ref object of OpenApiRestCall_597408
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsList_598030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsList_598029(
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
  var valid_598031 = path.getOrDefault("debuggeeId")
  valid_598031 = validateParameter(valid_598031, JString, required = true,
                                 default = nil)
  if valid_598031 != nil:
    section.add "debuggeeId", valid_598031
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
  var valid_598032 = query.getOrDefault("upload_protocol")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "upload_protocol", valid_598032
  var valid_598033 = query.getOrDefault("fields")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "fields", valid_598033
  var valid_598034 = query.getOrDefault("quotaUser")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "quotaUser", valid_598034
  var valid_598035 = query.getOrDefault("includeAllUsers")
  valid_598035 = validateParameter(valid_598035, JBool, required = false, default = nil)
  if valid_598035 != nil:
    section.add "includeAllUsers", valid_598035
  var valid_598036 = query.getOrDefault("alt")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = newJString("json"))
  if valid_598036 != nil:
    section.add "alt", valid_598036
  var valid_598037 = query.getOrDefault("includeInactive")
  valid_598037 = validateParameter(valid_598037, JBool, required = false, default = nil)
  if valid_598037 != nil:
    section.add "includeInactive", valid_598037
  var valid_598038 = query.getOrDefault("action.value")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = newJString("CAPTURE"))
  if valid_598038 != nil:
    section.add "action.value", valid_598038
  var valid_598039 = query.getOrDefault("oauth_token")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "oauth_token", valid_598039
  var valid_598040 = query.getOrDefault("callback")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "callback", valid_598040
  var valid_598041 = query.getOrDefault("access_token")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "access_token", valid_598041
  var valid_598042 = query.getOrDefault("uploadType")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = nil)
  if valid_598042 != nil:
    section.add "uploadType", valid_598042
  var valid_598043 = query.getOrDefault("stripResults")
  valid_598043 = validateParameter(valid_598043, JBool, required = false, default = nil)
  if valid_598043 != nil:
    section.add "stripResults", valid_598043
  var valid_598044 = query.getOrDefault("key")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = nil)
  if valid_598044 != nil:
    section.add "key", valid_598044
  var valid_598045 = query.getOrDefault("$.xgafv")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = newJString("1"))
  if valid_598045 != nil:
    section.add "$.xgafv", valid_598045
  var valid_598046 = query.getOrDefault("prettyPrint")
  valid_598046 = validateParameter(valid_598046, JBool, required = false,
                                 default = newJBool(true))
  if valid_598046 != nil:
    section.add "prettyPrint", valid_598046
  var valid_598047 = query.getOrDefault("clientVersion")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "clientVersion", valid_598047
  var valid_598048 = query.getOrDefault("waitToken")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "waitToken", valid_598048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598049: Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_598028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all breakpoints for the debuggee.
  ## 
  let valid = call_598049.validator(path, query, header, formData, body)
  let scheme = call_598049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598049.url(scheme.get, call_598049.host, call_598049.base,
                         call_598049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598049, url, valid)

proc call*(call_598050: Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_598028;
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
  var path_598051 = newJObject()
  var query_598052 = newJObject()
  add(query_598052, "upload_protocol", newJString(uploadProtocol))
  add(path_598051, "debuggeeId", newJString(debuggeeId))
  add(query_598052, "fields", newJString(fields))
  add(query_598052, "quotaUser", newJString(quotaUser))
  add(query_598052, "includeAllUsers", newJBool(includeAllUsers))
  add(query_598052, "alt", newJString(alt))
  add(query_598052, "includeInactive", newJBool(includeInactive))
  add(query_598052, "action.value", newJString(actionValue))
  add(query_598052, "oauth_token", newJString(oauthToken))
  add(query_598052, "callback", newJString(callback))
  add(query_598052, "access_token", newJString(accessToken))
  add(query_598052, "uploadType", newJString(uploadType))
  add(query_598052, "stripResults", newJBool(stripResults))
  add(query_598052, "key", newJString(key))
  add(query_598052, "$.xgafv", newJString(Xgafv))
  add(query_598052, "prettyPrint", newJBool(prettyPrint))
  add(query_598052, "clientVersion", newJString(clientVersion))
  add(query_598052, "waitToken", newJString(waitToken))
  result = call_598050.call(path_598051, query_598052, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsList* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_598028(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsList",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsList_598029,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsList_598030,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_598053 = ref object of OpenApiRestCall_597408
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsSet_598055(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsSet_598054(path: JsonNode;
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
  var valid_598056 = path.getOrDefault("debuggeeId")
  valid_598056 = validateParameter(valid_598056, JString, required = true,
                                 default = nil)
  if valid_598056 != nil:
    section.add "debuggeeId", valid_598056
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
  var valid_598057 = query.getOrDefault("upload_protocol")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "upload_protocol", valid_598057
  var valid_598058 = query.getOrDefault("fields")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "fields", valid_598058
  var valid_598059 = query.getOrDefault("quotaUser")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "quotaUser", valid_598059
  var valid_598060 = query.getOrDefault("alt")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = newJString("json"))
  if valid_598060 != nil:
    section.add "alt", valid_598060
  var valid_598061 = query.getOrDefault("oauth_token")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "oauth_token", valid_598061
  var valid_598062 = query.getOrDefault("callback")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "callback", valid_598062
  var valid_598063 = query.getOrDefault("access_token")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "access_token", valid_598063
  var valid_598064 = query.getOrDefault("uploadType")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "uploadType", valid_598064
  var valid_598065 = query.getOrDefault("key")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "key", valid_598065
  var valid_598066 = query.getOrDefault("$.xgafv")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = newJString("1"))
  if valid_598066 != nil:
    section.add "$.xgafv", valid_598066
  var valid_598067 = query.getOrDefault("prettyPrint")
  valid_598067 = validateParameter(valid_598067, JBool, required = false,
                                 default = newJBool(true))
  if valid_598067 != nil:
    section.add "prettyPrint", valid_598067
  var valid_598068 = query.getOrDefault("clientVersion")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "clientVersion", valid_598068
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

proc call*(call_598070: Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_598053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the breakpoint to the debuggee.
  ## 
  let valid = call_598070.validator(path, query, header, formData, body)
  let scheme = call_598070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598070.url(scheme.get, call_598070.host, call_598070.base,
                         call_598070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598070, url, valid)

proc call*(call_598071: Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_598053;
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
  var path_598072 = newJObject()
  var query_598073 = newJObject()
  var body_598074 = newJObject()
  add(query_598073, "upload_protocol", newJString(uploadProtocol))
  add(path_598072, "debuggeeId", newJString(debuggeeId))
  add(query_598073, "fields", newJString(fields))
  add(query_598073, "quotaUser", newJString(quotaUser))
  add(query_598073, "alt", newJString(alt))
  add(query_598073, "oauth_token", newJString(oauthToken))
  add(query_598073, "callback", newJString(callback))
  add(query_598073, "access_token", newJString(accessToken))
  add(query_598073, "uploadType", newJString(uploadType))
  add(query_598073, "key", newJString(key))
  add(query_598073, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598074 = body
  add(query_598073, "prettyPrint", newJBool(prettyPrint))
  add(query_598073, "clientVersion", newJString(clientVersion))
  result = call_598071.call(path_598072, query_598073, nil, nil, body_598074)

var clouddebuggerDebuggerDebuggeesBreakpointsSet* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_598053(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsSet",
    meth: HttpMethod.HttpPost, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/set",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsSet_598054,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsSet_598055,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_598075 = ref object of OpenApiRestCall_597408
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsGet_598077(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsGet_598076(path: JsonNode;
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
  var valid_598078 = path.getOrDefault("debuggeeId")
  valid_598078 = validateParameter(valid_598078, JString, required = true,
                                 default = nil)
  if valid_598078 != nil:
    section.add "debuggeeId", valid_598078
  var valid_598079 = path.getOrDefault("breakpointId")
  valid_598079 = validateParameter(valid_598079, JString, required = true,
                                 default = nil)
  if valid_598079 != nil:
    section.add "breakpointId", valid_598079
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
  var valid_598080 = query.getOrDefault("upload_protocol")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "upload_protocol", valid_598080
  var valid_598081 = query.getOrDefault("fields")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "fields", valid_598081
  var valid_598082 = query.getOrDefault("quotaUser")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "quotaUser", valid_598082
  var valid_598083 = query.getOrDefault("alt")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = newJString("json"))
  if valid_598083 != nil:
    section.add "alt", valid_598083
  var valid_598084 = query.getOrDefault("oauth_token")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "oauth_token", valid_598084
  var valid_598085 = query.getOrDefault("callback")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "callback", valid_598085
  var valid_598086 = query.getOrDefault("access_token")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "access_token", valid_598086
  var valid_598087 = query.getOrDefault("uploadType")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "uploadType", valid_598087
  var valid_598088 = query.getOrDefault("key")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = nil)
  if valid_598088 != nil:
    section.add "key", valid_598088
  var valid_598089 = query.getOrDefault("$.xgafv")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = newJString("1"))
  if valid_598089 != nil:
    section.add "$.xgafv", valid_598089
  var valid_598090 = query.getOrDefault("prettyPrint")
  valid_598090 = validateParameter(valid_598090, JBool, required = false,
                                 default = newJBool(true))
  if valid_598090 != nil:
    section.add "prettyPrint", valid_598090
  var valid_598091 = query.getOrDefault("clientVersion")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "clientVersion", valid_598091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598092: Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_598075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets breakpoint information.
  ## 
  let valid = call_598092.validator(path, query, header, formData, body)
  let scheme = call_598092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598092.url(scheme.get, call_598092.host, call_598092.base,
                         call_598092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598092, url, valid)

proc call*(call_598093: Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_598075;
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
  var path_598094 = newJObject()
  var query_598095 = newJObject()
  add(query_598095, "upload_protocol", newJString(uploadProtocol))
  add(path_598094, "debuggeeId", newJString(debuggeeId))
  add(query_598095, "fields", newJString(fields))
  add(query_598095, "quotaUser", newJString(quotaUser))
  add(query_598095, "alt", newJString(alt))
  add(path_598094, "breakpointId", newJString(breakpointId))
  add(query_598095, "oauth_token", newJString(oauthToken))
  add(query_598095, "callback", newJString(callback))
  add(query_598095, "access_token", newJString(accessToken))
  add(query_598095, "uploadType", newJString(uploadType))
  add(query_598095, "key", newJString(key))
  add(query_598095, "$.xgafv", newJString(Xgafv))
  add(query_598095, "prettyPrint", newJBool(prettyPrint))
  add(query_598095, "clientVersion", newJString(clientVersion))
  result = call_598093.call(path_598094, query_598095, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsGet* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_598075(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsGet",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/{breakpointId}",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsGet_598076,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsGet_598077,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_598096 = ref object of OpenApiRestCall_597408
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_598098(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_598097(
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
  var valid_598099 = path.getOrDefault("debuggeeId")
  valid_598099 = validateParameter(valid_598099, JString, required = true,
                                 default = nil)
  if valid_598099 != nil:
    section.add "debuggeeId", valid_598099
  var valid_598100 = path.getOrDefault("breakpointId")
  valid_598100 = validateParameter(valid_598100, JString, required = true,
                                 default = nil)
  if valid_598100 != nil:
    section.add "breakpointId", valid_598100
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
  var valid_598101 = query.getOrDefault("upload_protocol")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "upload_protocol", valid_598101
  var valid_598102 = query.getOrDefault("fields")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "fields", valid_598102
  var valid_598103 = query.getOrDefault("quotaUser")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "quotaUser", valid_598103
  var valid_598104 = query.getOrDefault("alt")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = newJString("json"))
  if valid_598104 != nil:
    section.add "alt", valid_598104
  var valid_598105 = query.getOrDefault("oauth_token")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "oauth_token", valid_598105
  var valid_598106 = query.getOrDefault("callback")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "callback", valid_598106
  var valid_598107 = query.getOrDefault("access_token")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "access_token", valid_598107
  var valid_598108 = query.getOrDefault("uploadType")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "uploadType", valid_598108
  var valid_598109 = query.getOrDefault("key")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = nil)
  if valid_598109 != nil:
    section.add "key", valid_598109
  var valid_598110 = query.getOrDefault("$.xgafv")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = newJString("1"))
  if valid_598110 != nil:
    section.add "$.xgafv", valid_598110
  var valid_598111 = query.getOrDefault("prettyPrint")
  valid_598111 = validateParameter(valid_598111, JBool, required = false,
                                 default = newJBool(true))
  if valid_598111 != nil:
    section.add "prettyPrint", valid_598111
  var valid_598112 = query.getOrDefault("clientVersion")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "clientVersion", valid_598112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598113: Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_598096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the breakpoint from the debuggee.
  ## 
  let valid = call_598113.validator(path, query, header, formData, body)
  let scheme = call_598113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598113.url(scheme.get, call_598113.host, call_598113.base,
                         call_598113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598113, url, valid)

proc call*(call_598114: Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_598096;
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
  var path_598115 = newJObject()
  var query_598116 = newJObject()
  add(query_598116, "upload_protocol", newJString(uploadProtocol))
  add(path_598115, "debuggeeId", newJString(debuggeeId))
  add(query_598116, "fields", newJString(fields))
  add(query_598116, "quotaUser", newJString(quotaUser))
  add(query_598116, "alt", newJString(alt))
  add(path_598115, "breakpointId", newJString(breakpointId))
  add(query_598116, "oauth_token", newJString(oauthToken))
  add(query_598116, "callback", newJString(callback))
  add(query_598116, "access_token", newJString(accessToken))
  add(query_598116, "uploadType", newJString(uploadType))
  add(query_598116, "key", newJString(key))
  add(query_598116, "$.xgafv", newJString(Xgafv))
  add(query_598116, "prettyPrint", newJBool(prettyPrint))
  add(query_598116, "clientVersion", newJString(clientVersion))
  result = call_598114.call(path_598115, query_598116, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsDelete* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_598096(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsDelete",
    meth: HttpMethod.HttpDelete, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/{breakpointId}",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_598097,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_598098,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
