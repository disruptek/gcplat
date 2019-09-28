
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouddebuggerControllerDebuggeesRegister_579677 = ref object of OpenApiRestCall_579408
proc url_ClouddebuggerControllerDebuggeesRegister_579679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClouddebuggerControllerDebuggeesRegister_579678(path: JsonNode;
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
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("quotaUser")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "quotaUser", valid_579793
  var valid_579807 = query.getOrDefault("alt")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = newJString("json"))
  if valid_579807 != nil:
    section.add "alt", valid_579807
  var valid_579808 = query.getOrDefault("oauth_token")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "oauth_token", valid_579808
  var valid_579809 = query.getOrDefault("callback")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "callback", valid_579809
  var valid_579810 = query.getOrDefault("access_token")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "access_token", valid_579810
  var valid_579811 = query.getOrDefault("uploadType")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "uploadType", valid_579811
  var valid_579812 = query.getOrDefault("key")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "key", valid_579812
  var valid_579813 = query.getOrDefault("$.xgafv")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = newJString("1"))
  if valid_579813 != nil:
    section.add "$.xgafv", valid_579813
  var valid_579814 = query.getOrDefault("prettyPrint")
  valid_579814 = validateParameter(valid_579814, JBool, required = false,
                                 default = newJBool(true))
  if valid_579814 != nil:
    section.add "prettyPrint", valid_579814
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

proc call*(call_579838: Call_ClouddebuggerControllerDebuggeesRegister_579677;
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
  let valid = call_579838.validator(path, query, header, formData, body)
  let scheme = call_579838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579838.url(scheme.get, call_579838.host, call_579838.base,
                         call_579838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579838, url, valid)

proc call*(call_579909: Call_ClouddebuggerControllerDebuggeesRegister_579677;
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
  var query_579910 = newJObject()
  var body_579912 = newJObject()
  add(query_579910, "upload_protocol", newJString(uploadProtocol))
  add(query_579910, "fields", newJString(fields))
  add(query_579910, "quotaUser", newJString(quotaUser))
  add(query_579910, "alt", newJString(alt))
  add(query_579910, "oauth_token", newJString(oauthToken))
  add(query_579910, "callback", newJString(callback))
  add(query_579910, "access_token", newJString(accessToken))
  add(query_579910, "uploadType", newJString(uploadType))
  add(query_579910, "key", newJString(key))
  add(query_579910, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579912 = body
  add(query_579910, "prettyPrint", newJBool(prettyPrint))
  result = call_579909.call(nil, query_579910, nil, nil, body_579912)

var clouddebuggerControllerDebuggeesRegister* = Call_ClouddebuggerControllerDebuggeesRegister_579677(
    name: "clouddebuggerControllerDebuggeesRegister", meth: HttpMethod.HttpPost,
    host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/register",
    validator: validate_ClouddebuggerControllerDebuggeesRegister_579678,
    base: "/", url: url_ClouddebuggerControllerDebuggeesRegister_579679,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerControllerDebuggeesBreakpointsList_579951 = ref object of OpenApiRestCall_579408
proc url_ClouddebuggerControllerDebuggeesBreakpointsList_579953(protocol: Scheme;
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

proc validate_ClouddebuggerControllerDebuggeesBreakpointsList_579952(
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
  var valid_579968 = path.getOrDefault("debuggeeId")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "debuggeeId", valid_579968
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("successOnTimeout")
  valid_579978 = validateParameter(valid_579978, JBool, required = false, default = nil)
  if valid_579978 != nil:
    section.add "successOnTimeout", valid_579978
  var valid_579979 = query.getOrDefault("$.xgafv")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("1"))
  if valid_579979 != nil:
    section.add "$.xgafv", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
  var valid_579981 = query.getOrDefault("waitToken")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "waitToken", valid_579981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579982: Call_ClouddebuggerControllerDebuggeesBreakpointsList_579951;
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
  let valid = call_579982.validator(path, query, header, formData, body)
  let scheme = call_579982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579982.url(scheme.get, call_579982.host, call_579982.base,
                         call_579982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579982, url, valid)

proc call*(call_579983: Call_ClouddebuggerControllerDebuggeesBreakpointsList_579951;
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
  var path_579984 = newJObject()
  var query_579985 = newJObject()
  add(query_579985, "upload_protocol", newJString(uploadProtocol))
  add(path_579984, "debuggeeId", newJString(debuggeeId))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "callback", newJString(callback))
  add(query_579985, "access_token", newJString(accessToken))
  add(query_579985, "uploadType", newJString(uploadType))
  add(query_579985, "key", newJString(key))
  add(query_579985, "successOnTimeout", newJBool(successOnTimeout))
  add(query_579985, "$.xgafv", newJString(Xgafv))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  add(query_579985, "waitToken", newJString(waitToken))
  result = call_579983.call(path_579984, query_579985, nil, nil, nil)

var clouddebuggerControllerDebuggeesBreakpointsList* = Call_ClouddebuggerControllerDebuggeesBreakpointsList_579951(
    name: "clouddebuggerControllerDebuggeesBreakpointsList",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/{debuggeeId}/breakpoints",
    validator: validate_ClouddebuggerControllerDebuggeesBreakpointsList_579952,
    base: "/", url: url_ClouddebuggerControllerDebuggeesBreakpointsList_579953,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579986 = ref object of OpenApiRestCall_579408
proc url_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579988(
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

proc validate_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579987(
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
  var valid_579989 = path.getOrDefault("debuggeeId")
  valid_579989 = validateParameter(valid_579989, JString, required = true,
                                 default = nil)
  if valid_579989 != nil:
    section.add "debuggeeId", valid_579989
  var valid_579990 = path.getOrDefault("id")
  valid_579990 = validateParameter(valid_579990, JString, required = true,
                                 default = nil)
  if valid_579990 != nil:
    section.add "id", valid_579990
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
  var valid_579991 = query.getOrDefault("upload_protocol")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "upload_protocol", valid_579991
  var valid_579992 = query.getOrDefault("fields")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "fields", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("alt")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("json"))
  if valid_579994 != nil:
    section.add "alt", valid_579994
  var valid_579995 = query.getOrDefault("oauth_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "oauth_token", valid_579995
  var valid_579996 = query.getOrDefault("callback")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "callback", valid_579996
  var valid_579997 = query.getOrDefault("access_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "access_token", valid_579997
  var valid_579998 = query.getOrDefault("uploadType")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "uploadType", valid_579998
  var valid_579999 = query.getOrDefault("key")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "key", valid_579999
  var valid_580000 = query.getOrDefault("$.xgafv")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("1"))
  if valid_580000 != nil:
    section.add "$.xgafv", valid_580000
  var valid_580001 = query.getOrDefault("prettyPrint")
  valid_580001 = validateParameter(valid_580001, JBool, required = false,
                                 default = newJBool(true))
  if valid_580001 != nil:
    section.add "prettyPrint", valid_580001
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

proc call*(call_580003: Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579986;
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
  let valid = call_580003.validator(path, query, header, formData, body)
  let scheme = call_580003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580003.url(scheme.get, call_580003.host, call_580003.base,
                         call_580003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580003, url, valid)

proc call*(call_580004: Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579986;
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
  var path_580005 = newJObject()
  var query_580006 = newJObject()
  var body_580007 = newJObject()
  add(query_580006, "upload_protocol", newJString(uploadProtocol))
  add(path_580005, "debuggeeId", newJString(debuggeeId))
  add(query_580006, "fields", newJString(fields))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(query_580006, "alt", newJString(alt))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "callback", newJString(callback))
  add(query_580006, "access_token", newJString(accessToken))
  add(query_580006, "uploadType", newJString(uploadType))
  add(path_580005, "id", newJString(id))
  add(query_580006, "key", newJString(key))
  add(query_580006, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580007 = body
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  result = call_580004.call(path_580005, query_580006, nil, nil, body_580007)

var clouddebuggerControllerDebuggeesBreakpointsUpdate* = Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579986(
    name: "clouddebuggerControllerDebuggeesBreakpointsUpdate",
    meth: HttpMethod.HttpPut, host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/{debuggeeId}/breakpoints/{id}",
    validator: validate_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579987,
    base: "/", url: url_ClouddebuggerControllerDebuggeesBreakpointsUpdate_579988,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesList_580008 = ref object of OpenApiRestCall_579408
proc url_ClouddebuggerDebuggerDebuggeesList_580010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClouddebuggerDebuggerDebuggeesList_580009(path: JsonNode;
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
  var valid_580011 = query.getOrDefault("upload_protocol")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "upload_protocol", valid_580011
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("includeInactive")
  valid_580015 = validateParameter(valid_580015, JBool, required = false, default = nil)
  if valid_580015 != nil:
    section.add "includeInactive", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("callback")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "callback", valid_580017
  var valid_580018 = query.getOrDefault("access_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "access_token", valid_580018
  var valid_580019 = query.getOrDefault("uploadType")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "uploadType", valid_580019
  var valid_580020 = query.getOrDefault("key")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "key", valid_580020
  var valid_580021 = query.getOrDefault("$.xgafv")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("1"))
  if valid_580021 != nil:
    section.add "$.xgafv", valid_580021
  var valid_580022 = query.getOrDefault("project")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "project", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  var valid_580024 = query.getOrDefault("clientVersion")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "clientVersion", valid_580024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580025: Call_ClouddebuggerDebuggerDebuggeesList_580008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the debuggees that the user has access to.
  ## 
  let valid = call_580025.validator(path, query, header, formData, body)
  let scheme = call_580025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580025.url(scheme.get, call_580025.host, call_580025.base,
                         call_580025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580025, url, valid)

proc call*(call_580026: Call_ClouddebuggerDebuggerDebuggeesList_580008;
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
  var query_580027 = newJObject()
  add(query_580027, "upload_protocol", newJString(uploadProtocol))
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "includeInactive", newJBool(includeInactive))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "callback", newJString(callback))
  add(query_580027, "access_token", newJString(accessToken))
  add(query_580027, "uploadType", newJString(uploadType))
  add(query_580027, "key", newJString(key))
  add(query_580027, "$.xgafv", newJString(Xgafv))
  add(query_580027, "project", newJString(project))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  add(query_580027, "clientVersion", newJString(clientVersion))
  result = call_580026.call(nil, query_580027, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesList* = Call_ClouddebuggerDebuggerDebuggeesList_580008(
    name: "clouddebuggerDebuggerDebuggeesList", meth: HttpMethod.HttpGet,
    host: "clouddebugger.googleapis.com", route: "/v2/debugger/debuggees",
    validator: validate_ClouddebuggerDebuggerDebuggeesList_580009, base: "/",
    url: url_ClouddebuggerDebuggerDebuggeesList_580010, schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_580028 = ref object of OpenApiRestCall_579408
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsList_580030(protocol: Scheme;
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsList_580029(
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
  var valid_580031 = path.getOrDefault("debuggeeId")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "debuggeeId", valid_580031
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
  var valid_580032 = query.getOrDefault("upload_protocol")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "upload_protocol", valid_580032
  var valid_580033 = query.getOrDefault("fields")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "fields", valid_580033
  var valid_580034 = query.getOrDefault("quotaUser")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "quotaUser", valid_580034
  var valid_580035 = query.getOrDefault("includeAllUsers")
  valid_580035 = validateParameter(valid_580035, JBool, required = false, default = nil)
  if valid_580035 != nil:
    section.add "includeAllUsers", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("includeInactive")
  valid_580037 = validateParameter(valid_580037, JBool, required = false, default = nil)
  if valid_580037 != nil:
    section.add "includeInactive", valid_580037
  var valid_580038 = query.getOrDefault("action.value")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("CAPTURE"))
  if valid_580038 != nil:
    section.add "action.value", valid_580038
  var valid_580039 = query.getOrDefault("oauth_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "oauth_token", valid_580039
  var valid_580040 = query.getOrDefault("callback")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "callback", valid_580040
  var valid_580041 = query.getOrDefault("access_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "access_token", valid_580041
  var valid_580042 = query.getOrDefault("uploadType")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "uploadType", valid_580042
  var valid_580043 = query.getOrDefault("stripResults")
  valid_580043 = validateParameter(valid_580043, JBool, required = false, default = nil)
  if valid_580043 != nil:
    section.add "stripResults", valid_580043
  var valid_580044 = query.getOrDefault("key")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "key", valid_580044
  var valid_580045 = query.getOrDefault("$.xgafv")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = newJString("1"))
  if valid_580045 != nil:
    section.add "$.xgafv", valid_580045
  var valid_580046 = query.getOrDefault("prettyPrint")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(true))
  if valid_580046 != nil:
    section.add "prettyPrint", valid_580046
  var valid_580047 = query.getOrDefault("clientVersion")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "clientVersion", valid_580047
  var valid_580048 = query.getOrDefault("waitToken")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "waitToken", valid_580048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580049: Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_580028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all breakpoints for the debuggee.
  ## 
  let valid = call_580049.validator(path, query, header, formData, body)
  let scheme = call_580049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580049.url(scheme.get, call_580049.host, call_580049.base,
                         call_580049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580049, url, valid)

proc call*(call_580050: Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_580028;
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
  var path_580051 = newJObject()
  var query_580052 = newJObject()
  add(query_580052, "upload_protocol", newJString(uploadProtocol))
  add(path_580051, "debuggeeId", newJString(debuggeeId))
  add(query_580052, "fields", newJString(fields))
  add(query_580052, "quotaUser", newJString(quotaUser))
  add(query_580052, "includeAllUsers", newJBool(includeAllUsers))
  add(query_580052, "alt", newJString(alt))
  add(query_580052, "includeInactive", newJBool(includeInactive))
  add(query_580052, "action.value", newJString(actionValue))
  add(query_580052, "oauth_token", newJString(oauthToken))
  add(query_580052, "callback", newJString(callback))
  add(query_580052, "access_token", newJString(accessToken))
  add(query_580052, "uploadType", newJString(uploadType))
  add(query_580052, "stripResults", newJBool(stripResults))
  add(query_580052, "key", newJString(key))
  add(query_580052, "$.xgafv", newJString(Xgafv))
  add(query_580052, "prettyPrint", newJBool(prettyPrint))
  add(query_580052, "clientVersion", newJString(clientVersion))
  add(query_580052, "waitToken", newJString(waitToken))
  result = call_580050.call(path_580051, query_580052, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsList* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_580028(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsList",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsList_580029,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsList_580030,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580053 = ref object of OpenApiRestCall_579408
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580055(protocol: Scheme;
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580054(path: JsonNode;
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
  var valid_580056 = path.getOrDefault("debuggeeId")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "debuggeeId", valid_580056
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
  var valid_580057 = query.getOrDefault("upload_protocol")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "upload_protocol", valid_580057
  var valid_580058 = query.getOrDefault("fields")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "fields", valid_580058
  var valid_580059 = query.getOrDefault("quotaUser")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "quotaUser", valid_580059
  var valid_580060 = query.getOrDefault("alt")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("json"))
  if valid_580060 != nil:
    section.add "alt", valid_580060
  var valid_580061 = query.getOrDefault("oauth_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "oauth_token", valid_580061
  var valid_580062 = query.getOrDefault("callback")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "callback", valid_580062
  var valid_580063 = query.getOrDefault("access_token")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "access_token", valid_580063
  var valid_580064 = query.getOrDefault("uploadType")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "uploadType", valid_580064
  var valid_580065 = query.getOrDefault("key")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "key", valid_580065
  var valid_580066 = query.getOrDefault("$.xgafv")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("1"))
  if valid_580066 != nil:
    section.add "$.xgafv", valid_580066
  var valid_580067 = query.getOrDefault("prettyPrint")
  valid_580067 = validateParameter(valid_580067, JBool, required = false,
                                 default = newJBool(true))
  if valid_580067 != nil:
    section.add "prettyPrint", valid_580067
  var valid_580068 = query.getOrDefault("clientVersion")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "clientVersion", valid_580068
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

proc call*(call_580070: Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the breakpoint to the debuggee.
  ## 
  let valid = call_580070.validator(path, query, header, formData, body)
  let scheme = call_580070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580070.url(scheme.get, call_580070.host, call_580070.base,
                         call_580070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580070, url, valid)

proc call*(call_580071: Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580053;
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
  var path_580072 = newJObject()
  var query_580073 = newJObject()
  var body_580074 = newJObject()
  add(query_580073, "upload_protocol", newJString(uploadProtocol))
  add(path_580072, "debuggeeId", newJString(debuggeeId))
  add(query_580073, "fields", newJString(fields))
  add(query_580073, "quotaUser", newJString(quotaUser))
  add(query_580073, "alt", newJString(alt))
  add(query_580073, "oauth_token", newJString(oauthToken))
  add(query_580073, "callback", newJString(callback))
  add(query_580073, "access_token", newJString(accessToken))
  add(query_580073, "uploadType", newJString(uploadType))
  add(query_580073, "key", newJString(key))
  add(query_580073, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580074 = body
  add(query_580073, "prettyPrint", newJBool(prettyPrint))
  add(query_580073, "clientVersion", newJString(clientVersion))
  result = call_580071.call(path_580072, query_580073, nil, nil, body_580074)

var clouddebuggerDebuggerDebuggeesBreakpointsSet* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580053(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsSet",
    meth: HttpMethod.HttpPost, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/set",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580054,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsSet_580055,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580075 = ref object of OpenApiRestCall_579408
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580077(protocol: Scheme;
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580076(path: JsonNode;
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
  var valid_580078 = path.getOrDefault("debuggeeId")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "debuggeeId", valid_580078
  var valid_580079 = path.getOrDefault("breakpointId")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "breakpointId", valid_580079
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
  var valid_580080 = query.getOrDefault("upload_protocol")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "upload_protocol", valid_580080
  var valid_580081 = query.getOrDefault("fields")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "fields", valid_580081
  var valid_580082 = query.getOrDefault("quotaUser")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "quotaUser", valid_580082
  var valid_580083 = query.getOrDefault("alt")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("json"))
  if valid_580083 != nil:
    section.add "alt", valid_580083
  var valid_580084 = query.getOrDefault("oauth_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "oauth_token", valid_580084
  var valid_580085 = query.getOrDefault("callback")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "callback", valid_580085
  var valid_580086 = query.getOrDefault("access_token")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "access_token", valid_580086
  var valid_580087 = query.getOrDefault("uploadType")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "uploadType", valid_580087
  var valid_580088 = query.getOrDefault("key")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "key", valid_580088
  var valid_580089 = query.getOrDefault("$.xgafv")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = newJString("1"))
  if valid_580089 != nil:
    section.add "$.xgafv", valid_580089
  var valid_580090 = query.getOrDefault("prettyPrint")
  valid_580090 = validateParameter(valid_580090, JBool, required = false,
                                 default = newJBool(true))
  if valid_580090 != nil:
    section.add "prettyPrint", valid_580090
  var valid_580091 = query.getOrDefault("clientVersion")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "clientVersion", valid_580091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580092: Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets breakpoint information.
  ## 
  let valid = call_580092.validator(path, query, header, formData, body)
  let scheme = call_580092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580092.url(scheme.get, call_580092.host, call_580092.base,
                         call_580092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580092, url, valid)

proc call*(call_580093: Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580075;
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
  var path_580094 = newJObject()
  var query_580095 = newJObject()
  add(query_580095, "upload_protocol", newJString(uploadProtocol))
  add(path_580094, "debuggeeId", newJString(debuggeeId))
  add(query_580095, "fields", newJString(fields))
  add(query_580095, "quotaUser", newJString(quotaUser))
  add(query_580095, "alt", newJString(alt))
  add(path_580094, "breakpointId", newJString(breakpointId))
  add(query_580095, "oauth_token", newJString(oauthToken))
  add(query_580095, "callback", newJString(callback))
  add(query_580095, "access_token", newJString(accessToken))
  add(query_580095, "uploadType", newJString(uploadType))
  add(query_580095, "key", newJString(key))
  add(query_580095, "$.xgafv", newJString(Xgafv))
  add(query_580095, "prettyPrint", newJBool(prettyPrint))
  add(query_580095, "clientVersion", newJString(clientVersion))
  result = call_580093.call(path_580094, query_580095, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsGet* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580075(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsGet",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/{breakpointId}",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580076,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsGet_580077,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580096 = ref object of OpenApiRestCall_579408
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580098(protocol: Scheme;
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580097(
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
  var valid_580099 = path.getOrDefault("debuggeeId")
  valid_580099 = validateParameter(valid_580099, JString, required = true,
                                 default = nil)
  if valid_580099 != nil:
    section.add "debuggeeId", valid_580099
  var valid_580100 = path.getOrDefault("breakpointId")
  valid_580100 = validateParameter(valid_580100, JString, required = true,
                                 default = nil)
  if valid_580100 != nil:
    section.add "breakpointId", valid_580100
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
  var valid_580101 = query.getOrDefault("upload_protocol")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "upload_protocol", valid_580101
  var valid_580102 = query.getOrDefault("fields")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "fields", valid_580102
  var valid_580103 = query.getOrDefault("quotaUser")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "quotaUser", valid_580103
  var valid_580104 = query.getOrDefault("alt")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("json"))
  if valid_580104 != nil:
    section.add "alt", valid_580104
  var valid_580105 = query.getOrDefault("oauth_token")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "oauth_token", valid_580105
  var valid_580106 = query.getOrDefault("callback")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "callback", valid_580106
  var valid_580107 = query.getOrDefault("access_token")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "access_token", valid_580107
  var valid_580108 = query.getOrDefault("uploadType")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "uploadType", valid_580108
  var valid_580109 = query.getOrDefault("key")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "key", valid_580109
  var valid_580110 = query.getOrDefault("$.xgafv")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = newJString("1"))
  if valid_580110 != nil:
    section.add "$.xgafv", valid_580110
  var valid_580111 = query.getOrDefault("prettyPrint")
  valid_580111 = validateParameter(valid_580111, JBool, required = false,
                                 default = newJBool(true))
  if valid_580111 != nil:
    section.add "prettyPrint", valid_580111
  var valid_580112 = query.getOrDefault("clientVersion")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "clientVersion", valid_580112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580113: Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the breakpoint from the debuggee.
  ## 
  let valid = call_580113.validator(path, query, header, formData, body)
  let scheme = call_580113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580113.url(scheme.get, call_580113.host, call_580113.base,
                         call_580113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580113, url, valid)

proc call*(call_580114: Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580096;
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
  var path_580115 = newJObject()
  var query_580116 = newJObject()
  add(query_580116, "upload_protocol", newJString(uploadProtocol))
  add(path_580115, "debuggeeId", newJString(debuggeeId))
  add(query_580116, "fields", newJString(fields))
  add(query_580116, "quotaUser", newJString(quotaUser))
  add(query_580116, "alt", newJString(alt))
  add(path_580115, "breakpointId", newJString(breakpointId))
  add(query_580116, "oauth_token", newJString(oauthToken))
  add(query_580116, "callback", newJString(callback))
  add(query_580116, "access_token", newJString(accessToken))
  add(query_580116, "uploadType", newJString(uploadType))
  add(query_580116, "key", newJString(key))
  add(query_580116, "$.xgafv", newJString(Xgafv))
  add(query_580116, "prettyPrint", newJBool(prettyPrint))
  add(query_580116, "clientVersion", newJString(clientVersion))
  result = call_580114.call(path_580115, query_580116, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsDelete* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580096(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsDelete",
    meth: HttpMethod.HttpDelete, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/{breakpointId}",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580097,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_580098,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
