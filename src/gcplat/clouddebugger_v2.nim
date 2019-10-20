
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "clouddebugger"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouddebuggerControllerDebuggeesRegister_578610 = ref object of OpenApiRestCall_578339
proc url_ClouddebuggerControllerDebuggeesRegister_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClouddebuggerControllerDebuggeesRegister_578611(path: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("$.xgafv")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("1"))
  if valid_578740 != nil:
    section.add "$.xgafv", valid_578740
  var valid_578741 = query.getOrDefault("alt")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = newJString("json"))
  if valid_578741 != nil:
    section.add "alt", valid_578741
  var valid_578742 = query.getOrDefault("uploadType")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "uploadType", valid_578742
  var valid_578743 = query.getOrDefault("quotaUser")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "quotaUser", valid_578743
  var valid_578744 = query.getOrDefault("callback")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "callback", valid_578744
  var valid_578745 = query.getOrDefault("fields")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "fields", valid_578745
  var valid_578746 = query.getOrDefault("access_token")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "access_token", valid_578746
  var valid_578747 = query.getOrDefault("upload_protocol")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "upload_protocol", valid_578747
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

proc call*(call_578771: Call_ClouddebuggerControllerDebuggeesRegister_578610;
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
  let valid = call_578771.validator(path, query, header, formData, body)
  let scheme = call_578771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578771.url(scheme.get, call_578771.host, call_578771.base,
                         call_578771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578771, url, valid)

proc call*(call_578842: Call_ClouddebuggerControllerDebuggeesRegister_578610;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578843 = newJObject()
  var body_578845 = newJObject()
  add(query_578843, "key", newJString(key))
  add(query_578843, "prettyPrint", newJBool(prettyPrint))
  add(query_578843, "oauth_token", newJString(oauthToken))
  add(query_578843, "$.xgafv", newJString(Xgafv))
  add(query_578843, "alt", newJString(alt))
  add(query_578843, "uploadType", newJString(uploadType))
  add(query_578843, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578845 = body
  add(query_578843, "callback", newJString(callback))
  add(query_578843, "fields", newJString(fields))
  add(query_578843, "access_token", newJString(accessToken))
  add(query_578843, "upload_protocol", newJString(uploadProtocol))
  result = call_578842.call(nil, query_578843, nil, nil, body_578845)

var clouddebuggerControllerDebuggeesRegister* = Call_ClouddebuggerControllerDebuggeesRegister_578610(
    name: "clouddebuggerControllerDebuggeesRegister", meth: HttpMethod.HttpPost,
    host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/register",
    validator: validate_ClouddebuggerControllerDebuggeesRegister_578611,
    base: "/", url: url_ClouddebuggerControllerDebuggeesRegister_578612,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerControllerDebuggeesBreakpointsList_578884 = ref object of OpenApiRestCall_578339
proc url_ClouddebuggerControllerDebuggeesBreakpointsList_578886(protocol: Scheme;
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

proc validate_ClouddebuggerControllerDebuggeesBreakpointsList_578885(
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
  var valid_578901 = path.getOrDefault("debuggeeId")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "debuggeeId", valid_578901
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   waitToken: JString
  ##            : A token that, if specified, blocks the method call until the list
  ## of active breakpoints has changed, or a server-selected timeout has
  ## expired. The value should be set from the `next_wait_token` field in
  ## the last response. The initial value should be set to `"init"`.
  ##   successOnTimeout: JBool
  ##                   : If set to `true` (recommended), returns `google.rpc.Code.OK` status and
  ## sets the `wait_expired` response field to `true` when the server-selected
  ## timeout has expired.
  ## 
  ## If set to `false` (deprecated), returns `google.rpc.Code.ABORTED` status
  ## when the server-selected timeout has expired.
  section = newJObject()
  var valid_578902 = query.getOrDefault("key")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "key", valid_578902
  var valid_578903 = query.getOrDefault("prettyPrint")
  valid_578903 = validateParameter(valid_578903, JBool, required = false,
                                 default = newJBool(true))
  if valid_578903 != nil:
    section.add "prettyPrint", valid_578903
  var valid_578904 = query.getOrDefault("oauth_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "oauth_token", valid_578904
  var valid_578905 = query.getOrDefault("$.xgafv")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("1"))
  if valid_578905 != nil:
    section.add "$.xgafv", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("callback")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "callback", valid_578909
  var valid_578910 = query.getOrDefault("fields")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "fields", valid_578910
  var valid_578911 = query.getOrDefault("access_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "access_token", valid_578911
  var valid_578912 = query.getOrDefault("upload_protocol")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "upload_protocol", valid_578912
  var valid_578913 = query.getOrDefault("waitToken")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "waitToken", valid_578913
  var valid_578914 = query.getOrDefault("successOnTimeout")
  valid_578914 = validateParameter(valid_578914, JBool, required = false, default = nil)
  if valid_578914 != nil:
    section.add "successOnTimeout", valid_578914
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578915: Call_ClouddebuggerControllerDebuggeesBreakpointsList_578884;
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
  let valid = call_578915.validator(path, query, header, formData, body)
  let scheme = call_578915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578915.url(scheme.get, call_578915.host, call_578915.base,
                         call_578915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578915, url, valid)

proc call*(call_578916: Call_ClouddebuggerControllerDebuggeesBreakpointsList_578884;
          debuggeeId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          waitToken: string = ""; successOnTimeout: bool = false): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   debuggeeId: string (required)
  ##             : Identifies the debuggee.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   waitToken: string
  ##            : A token that, if specified, blocks the method call until the list
  ## of active breakpoints has changed, or a server-selected timeout has
  ## expired. The value should be set from the `next_wait_token` field in
  ## the last response. The initial value should be set to `"init"`.
  ##   successOnTimeout: bool
  ##                   : If set to `true` (recommended), returns `google.rpc.Code.OK` status and
  ## sets the `wait_expired` response field to `true` when the server-selected
  ## timeout has expired.
  ## 
  ## If set to `false` (deprecated), returns `google.rpc.Code.ABORTED` status
  ## when the server-selected timeout has expired.
  var path_578917 = newJObject()
  var query_578918 = newJObject()
  add(query_578918, "key", newJString(key))
  add(query_578918, "prettyPrint", newJBool(prettyPrint))
  add(query_578918, "oauth_token", newJString(oauthToken))
  add(query_578918, "$.xgafv", newJString(Xgafv))
  add(query_578918, "alt", newJString(alt))
  add(query_578918, "uploadType", newJString(uploadType))
  add(query_578918, "quotaUser", newJString(quotaUser))
  add(path_578917, "debuggeeId", newJString(debuggeeId))
  add(query_578918, "callback", newJString(callback))
  add(query_578918, "fields", newJString(fields))
  add(query_578918, "access_token", newJString(accessToken))
  add(query_578918, "upload_protocol", newJString(uploadProtocol))
  add(query_578918, "waitToken", newJString(waitToken))
  add(query_578918, "successOnTimeout", newJBool(successOnTimeout))
  result = call_578916.call(path_578917, query_578918, nil, nil, nil)

var clouddebuggerControllerDebuggeesBreakpointsList* = Call_ClouddebuggerControllerDebuggeesBreakpointsList_578884(
    name: "clouddebuggerControllerDebuggeesBreakpointsList",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/{debuggeeId}/breakpoints",
    validator: validate_ClouddebuggerControllerDebuggeesBreakpointsList_578885,
    base: "/", url: url_ClouddebuggerControllerDebuggeesBreakpointsList_578886,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_578919 = ref object of OpenApiRestCall_578339
proc url_ClouddebuggerControllerDebuggeesBreakpointsUpdate_578921(
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

proc validate_ClouddebuggerControllerDebuggeesBreakpointsUpdate_578920(
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
  ##   id: JString (required)
  ##     : Breakpoint identifier, unique in the scope of the debuggee.
  ##   debuggeeId: JString (required)
  ##             : Identifies the debuggee being debugged.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_578922 = path.getOrDefault("id")
  valid_578922 = validateParameter(valid_578922, JString, required = true,
                                 default = nil)
  if valid_578922 != nil:
    section.add "id", valid_578922
  var valid_578923 = path.getOrDefault("debuggeeId")
  valid_578923 = validateParameter(valid_578923, JString, required = true,
                                 default = nil)
  if valid_578923 != nil:
    section.add "debuggeeId", valid_578923
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578924 = query.getOrDefault("key")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "key", valid_578924
  var valid_578925 = query.getOrDefault("prettyPrint")
  valid_578925 = validateParameter(valid_578925, JBool, required = false,
                                 default = newJBool(true))
  if valid_578925 != nil:
    section.add "prettyPrint", valid_578925
  var valid_578926 = query.getOrDefault("oauth_token")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "oauth_token", valid_578926
  var valid_578927 = query.getOrDefault("$.xgafv")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = newJString("1"))
  if valid_578927 != nil:
    section.add "$.xgafv", valid_578927
  var valid_578928 = query.getOrDefault("alt")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("json"))
  if valid_578928 != nil:
    section.add "alt", valid_578928
  var valid_578929 = query.getOrDefault("uploadType")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "uploadType", valid_578929
  var valid_578930 = query.getOrDefault("quotaUser")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "quotaUser", valid_578930
  var valid_578931 = query.getOrDefault("callback")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "callback", valid_578931
  var valid_578932 = query.getOrDefault("fields")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "fields", valid_578932
  var valid_578933 = query.getOrDefault("access_token")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "access_token", valid_578933
  var valid_578934 = query.getOrDefault("upload_protocol")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "upload_protocol", valid_578934
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

proc call*(call_578936: Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_578919;
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
  let valid = call_578936.validator(path, query, header, formData, body)
  let scheme = call_578936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578936.url(scheme.get, call_578936.host, call_578936.base,
                         call_578936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578936, url, valid)

proc call*(call_578937: Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_578919;
          id: string; debuggeeId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## clouddebuggerControllerDebuggeesBreakpointsUpdate
  ## Updates the breakpoint state or mutable fields.
  ## The entire Breakpoint message must be sent back to the controller service.
  ## 
  ## Updates to active breakpoint fields are only allowed if the new value
  ## does not change the breakpoint specification. Updates to the `location`,
  ## `condition` and `expressions` fields should not alter the breakpoint
  ## semantics. These may only make changes such as canonicalizing a value
  ## or snapping the location to the correct line of code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Breakpoint identifier, unique in the scope of the debuggee.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   debuggeeId: string (required)
  ##             : Identifies the debuggee being debugged.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578938 = newJObject()
  var query_578939 = newJObject()
  var body_578940 = newJObject()
  add(query_578939, "key", newJString(key))
  add(query_578939, "prettyPrint", newJBool(prettyPrint))
  add(query_578939, "oauth_token", newJString(oauthToken))
  add(query_578939, "$.xgafv", newJString(Xgafv))
  add(path_578938, "id", newJString(id))
  add(query_578939, "alt", newJString(alt))
  add(query_578939, "uploadType", newJString(uploadType))
  add(query_578939, "quotaUser", newJString(quotaUser))
  add(path_578938, "debuggeeId", newJString(debuggeeId))
  if body != nil:
    body_578940 = body
  add(query_578939, "callback", newJString(callback))
  add(query_578939, "fields", newJString(fields))
  add(query_578939, "access_token", newJString(accessToken))
  add(query_578939, "upload_protocol", newJString(uploadProtocol))
  result = call_578937.call(path_578938, query_578939, nil, nil, body_578940)

var clouddebuggerControllerDebuggeesBreakpointsUpdate* = Call_ClouddebuggerControllerDebuggeesBreakpointsUpdate_578919(
    name: "clouddebuggerControllerDebuggeesBreakpointsUpdate",
    meth: HttpMethod.HttpPut, host: "clouddebugger.googleapis.com",
    route: "/v2/controller/debuggees/{debuggeeId}/breakpoints/{id}",
    validator: validate_ClouddebuggerControllerDebuggeesBreakpointsUpdate_578920,
    base: "/", url: url_ClouddebuggerControllerDebuggeesBreakpointsUpdate_578921,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesList_578941 = ref object of OpenApiRestCall_578339
proc url_ClouddebuggerDebuggerDebuggeesList_578943(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClouddebuggerDebuggerDebuggeesList_578942(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the debuggees that the user has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   project: JString
  ##          : Project number of a Google Cloud project whose debuggees to list.
  ##   callback: JString
  ##           : JSONP
  ##   includeInactive: JBool
  ##                  : When set to `true`, the result includes all debuggees. Otherwise, the
  ## result includes only debuggees that are active.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: JString
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_578944 = query.getOrDefault("key")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "key", valid_578944
  var valid_578945 = query.getOrDefault("prettyPrint")
  valid_578945 = validateParameter(valid_578945, JBool, required = false,
                                 default = newJBool(true))
  if valid_578945 != nil:
    section.add "prettyPrint", valid_578945
  var valid_578946 = query.getOrDefault("oauth_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "oauth_token", valid_578946
  var valid_578947 = query.getOrDefault("$.xgafv")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("1"))
  if valid_578947 != nil:
    section.add "$.xgafv", valid_578947
  var valid_578948 = query.getOrDefault("alt")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("json"))
  if valid_578948 != nil:
    section.add "alt", valid_578948
  var valid_578949 = query.getOrDefault("uploadType")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "uploadType", valid_578949
  var valid_578950 = query.getOrDefault("quotaUser")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "quotaUser", valid_578950
  var valid_578951 = query.getOrDefault("project")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "project", valid_578951
  var valid_578952 = query.getOrDefault("callback")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "callback", valid_578952
  var valid_578953 = query.getOrDefault("includeInactive")
  valid_578953 = validateParameter(valid_578953, JBool, required = false, default = nil)
  if valid_578953 != nil:
    section.add "includeInactive", valid_578953
  var valid_578954 = query.getOrDefault("fields")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "fields", valid_578954
  var valid_578955 = query.getOrDefault("access_token")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "access_token", valid_578955
  var valid_578956 = query.getOrDefault("upload_protocol")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "upload_protocol", valid_578956
  var valid_578957 = query.getOrDefault("clientVersion")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "clientVersion", valid_578957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578958: Call_ClouddebuggerDebuggerDebuggeesList_578941;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the debuggees that the user has access to.
  ## 
  let valid = call_578958.validator(path, query, header, formData, body)
  let scheme = call_578958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578958.url(scheme.get, call_578958.host, call_578958.base,
                         call_578958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578958, url, valid)

proc call*(call_578959: Call_ClouddebuggerDebuggerDebuggeesList_578941;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; project: string = ""; callback: string = "";
          includeInactive: bool = false; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesList
  ## Lists all the debuggees that the user has access to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   project: string
  ##          : Project number of a Google Cloud project whose debuggees to list.
  ##   callback: string
  ##           : JSONP
  ##   includeInactive: bool
  ##                  : When set to `true`, the result includes all debuggees. Otherwise, the
  ## result includes only debuggees that are active.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: string
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var query_578960 = newJObject()
  add(query_578960, "key", newJString(key))
  add(query_578960, "prettyPrint", newJBool(prettyPrint))
  add(query_578960, "oauth_token", newJString(oauthToken))
  add(query_578960, "$.xgafv", newJString(Xgafv))
  add(query_578960, "alt", newJString(alt))
  add(query_578960, "uploadType", newJString(uploadType))
  add(query_578960, "quotaUser", newJString(quotaUser))
  add(query_578960, "project", newJString(project))
  add(query_578960, "callback", newJString(callback))
  add(query_578960, "includeInactive", newJBool(includeInactive))
  add(query_578960, "fields", newJString(fields))
  add(query_578960, "access_token", newJString(accessToken))
  add(query_578960, "upload_protocol", newJString(uploadProtocol))
  add(query_578960, "clientVersion", newJString(clientVersion))
  result = call_578959.call(nil, query_578960, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesList* = Call_ClouddebuggerDebuggerDebuggeesList_578941(
    name: "clouddebuggerDebuggerDebuggeesList", meth: HttpMethod.HttpGet,
    host: "clouddebugger.googleapis.com", route: "/v2/debugger/debuggees",
    validator: validate_ClouddebuggerDebuggerDebuggeesList_578942, base: "/",
    url: url_ClouddebuggerDebuggerDebuggeesList_578943, schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_578961 = ref object of OpenApiRestCall_578339
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsList_578963(protocol: Scheme;
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsList_578962(
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
  var valid_578964 = path.getOrDefault("debuggeeId")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "debuggeeId", valid_578964
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   action.value: JString
  ##               : Only breakpoints with the specified action will pass the filter.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeAllUsers: JBool
  ##                  : When set to `true`, the response includes the list of breakpoints set by
  ## any user. Otherwise, it includes only breakpoints set by the caller.
  ##   stripResults: JBool
  ##               : This field is deprecated. The following fields are always stripped out of
  ## the result: `stack_frames`, `evaluated_expressions` and `variable_table`.
  ##   callback: JString
  ##           : JSONP
  ##   includeInactive: JBool
  ##                  : When set to `true`, the response includes active and inactive
  ## breakpoints. Otherwise, it includes only active breakpoints.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   waitToken: JString
  ##            : A wait token that, if specified, blocks the call until the breakpoints
  ## list has changed, or a server selected timeout has expired.  The value
  ## should be set from the last response. The error code
  ## `google.rpc.Code.ABORTED` (RPC) is returned on wait timeout, which
  ## should be called again with the same `wait_token`.
  ##   clientVersion: JString
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_578965 = query.getOrDefault("key")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "key", valid_578965
  var valid_578966 = query.getOrDefault("prettyPrint")
  valid_578966 = validateParameter(valid_578966, JBool, required = false,
                                 default = newJBool(true))
  if valid_578966 != nil:
    section.add "prettyPrint", valid_578966
  var valid_578967 = query.getOrDefault("oauth_token")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "oauth_token", valid_578967
  var valid_578968 = query.getOrDefault("$.xgafv")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("1"))
  if valid_578968 != nil:
    section.add "$.xgafv", valid_578968
  var valid_578969 = query.getOrDefault("action.value")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("CAPTURE"))
  if valid_578969 != nil:
    section.add "action.value", valid_578969
  var valid_578970 = query.getOrDefault("alt")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("json"))
  if valid_578970 != nil:
    section.add "alt", valid_578970
  var valid_578971 = query.getOrDefault("uploadType")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "uploadType", valid_578971
  var valid_578972 = query.getOrDefault("quotaUser")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "quotaUser", valid_578972
  var valid_578973 = query.getOrDefault("includeAllUsers")
  valid_578973 = validateParameter(valid_578973, JBool, required = false, default = nil)
  if valid_578973 != nil:
    section.add "includeAllUsers", valid_578973
  var valid_578974 = query.getOrDefault("stripResults")
  valid_578974 = validateParameter(valid_578974, JBool, required = false, default = nil)
  if valid_578974 != nil:
    section.add "stripResults", valid_578974
  var valid_578975 = query.getOrDefault("callback")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "callback", valid_578975
  var valid_578976 = query.getOrDefault("includeInactive")
  valid_578976 = validateParameter(valid_578976, JBool, required = false, default = nil)
  if valid_578976 != nil:
    section.add "includeInactive", valid_578976
  var valid_578977 = query.getOrDefault("fields")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "fields", valid_578977
  var valid_578978 = query.getOrDefault("access_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "access_token", valid_578978
  var valid_578979 = query.getOrDefault("upload_protocol")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "upload_protocol", valid_578979
  var valid_578980 = query.getOrDefault("waitToken")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "waitToken", valid_578980
  var valid_578981 = query.getOrDefault("clientVersion")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "clientVersion", valid_578981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578982: Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_578961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all breakpoints for the debuggee.
  ## 
  let valid = call_578982.validator(path, query, header, formData, body)
  let scheme = call_578982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578982.url(scheme.get, call_578982.host, call_578982.base,
                         call_578982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578982, url, valid)

proc call*(call_578983: Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_578961;
          debuggeeId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; actionValue: string = "CAPTURE";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          includeAllUsers: bool = false; stripResults: bool = false;
          callback: string = ""; includeInactive: bool = false; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; waitToken: string = "";
          clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsList
  ## Lists all breakpoints for the debuggee.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   actionValue: string
  ##              : Only breakpoints with the specified action will pass the filter.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeAllUsers: bool
  ##                  : When set to `true`, the response includes the list of breakpoints set by
  ## any user. Otherwise, it includes only breakpoints set by the caller.
  ##   stripResults: bool
  ##               : This field is deprecated. The following fields are always stripped out of
  ## the result: `stack_frames`, `evaluated_expressions` and `variable_table`.
  ##   debuggeeId: string (required)
  ##             : ID of the debuggee whose breakpoints to list.
  ##   callback: string
  ##           : JSONP
  ##   includeInactive: bool
  ##                  : When set to `true`, the response includes active and inactive
  ## breakpoints. Otherwise, it includes only active breakpoints.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   waitToken: string
  ##            : A wait token that, if specified, blocks the call until the breakpoints
  ## list has changed, or a server selected timeout has expired.  The value
  ## should be set from the last response. The error code
  ## `google.rpc.Code.ABORTED` (RPC) is returned on wait timeout, which
  ## should be called again with the same `wait_token`.
  ##   clientVersion: string
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var path_578984 = newJObject()
  var query_578985 = newJObject()
  add(query_578985, "key", newJString(key))
  add(query_578985, "prettyPrint", newJBool(prettyPrint))
  add(query_578985, "oauth_token", newJString(oauthToken))
  add(query_578985, "$.xgafv", newJString(Xgafv))
  add(query_578985, "action.value", newJString(actionValue))
  add(query_578985, "alt", newJString(alt))
  add(query_578985, "uploadType", newJString(uploadType))
  add(query_578985, "quotaUser", newJString(quotaUser))
  add(query_578985, "includeAllUsers", newJBool(includeAllUsers))
  add(query_578985, "stripResults", newJBool(stripResults))
  add(path_578984, "debuggeeId", newJString(debuggeeId))
  add(query_578985, "callback", newJString(callback))
  add(query_578985, "includeInactive", newJBool(includeInactive))
  add(query_578985, "fields", newJString(fields))
  add(query_578985, "access_token", newJString(accessToken))
  add(query_578985, "upload_protocol", newJString(uploadProtocol))
  add(query_578985, "waitToken", newJString(waitToken))
  add(query_578985, "clientVersion", newJString(clientVersion))
  result = call_578983.call(path_578984, query_578985, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsList* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsList_578961(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsList",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsList_578962,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsList_578963,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_578986 = ref object of OpenApiRestCall_578339
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsSet_578988(protocol: Scheme;
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsSet_578987(path: JsonNode;
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
  var valid_578989 = path.getOrDefault("debuggeeId")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "debuggeeId", valid_578989
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: JString
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("$.xgafv")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("1"))
  if valid_578993 != nil:
    section.add "$.xgafv", valid_578993
  var valid_578994 = query.getOrDefault("alt")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = newJString("json"))
  if valid_578994 != nil:
    section.add "alt", valid_578994
  var valid_578995 = query.getOrDefault("uploadType")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "uploadType", valid_578995
  var valid_578996 = query.getOrDefault("quotaUser")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "quotaUser", valid_578996
  var valid_578997 = query.getOrDefault("callback")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "callback", valid_578997
  var valid_578998 = query.getOrDefault("fields")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "fields", valid_578998
  var valid_578999 = query.getOrDefault("access_token")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "access_token", valid_578999
  var valid_579000 = query.getOrDefault("upload_protocol")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "upload_protocol", valid_579000
  var valid_579001 = query.getOrDefault("clientVersion")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "clientVersion", valid_579001
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

proc call*(call_579003: Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_578986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the breakpoint to the debuggee.
  ## 
  let valid = call_579003.validator(path, query, header, formData, body)
  let scheme = call_579003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579003.url(scheme.get, call_579003.host, call_579003.base,
                         call_579003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579003, url, valid)

proc call*(call_579004: Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_578986;
          debuggeeId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsSet
  ## Sets the breakpoint to the debuggee.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   debuggeeId: string (required)
  ##             : ID of the debuggee where the breakpoint is to be set.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: string
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var path_579005 = newJObject()
  var query_579006 = newJObject()
  var body_579007 = newJObject()
  add(query_579006, "key", newJString(key))
  add(query_579006, "prettyPrint", newJBool(prettyPrint))
  add(query_579006, "oauth_token", newJString(oauthToken))
  add(query_579006, "$.xgafv", newJString(Xgafv))
  add(query_579006, "alt", newJString(alt))
  add(query_579006, "uploadType", newJString(uploadType))
  add(query_579006, "quotaUser", newJString(quotaUser))
  add(path_579005, "debuggeeId", newJString(debuggeeId))
  if body != nil:
    body_579007 = body
  add(query_579006, "callback", newJString(callback))
  add(query_579006, "fields", newJString(fields))
  add(query_579006, "access_token", newJString(accessToken))
  add(query_579006, "upload_protocol", newJString(uploadProtocol))
  add(query_579006, "clientVersion", newJString(clientVersion))
  result = call_579004.call(path_579005, query_579006, nil, nil, body_579007)

var clouddebuggerDebuggerDebuggeesBreakpointsSet* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsSet_578986(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsSet",
    meth: HttpMethod.HttpPost, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/set",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsSet_578987,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsSet_578988,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_579008 = ref object of OpenApiRestCall_578339
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsGet_579010(protocol: Scheme;
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsGet_579009(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets breakpoint information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   breakpointId: JString (required)
  ##               : ID of the breakpoint to get.
  ##   debuggeeId: JString (required)
  ##             : ID of the debuggee whose breakpoint to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `breakpointId` field"
  var valid_579011 = path.getOrDefault("breakpointId")
  valid_579011 = validateParameter(valid_579011, JString, required = true,
                                 default = nil)
  if valid_579011 != nil:
    section.add "breakpointId", valid_579011
  var valid_579012 = path.getOrDefault("debuggeeId")
  valid_579012 = validateParameter(valid_579012, JString, required = true,
                                 default = nil)
  if valid_579012 != nil:
    section.add "debuggeeId", valid_579012
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: JString
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_579013 = query.getOrDefault("key")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "key", valid_579013
  var valid_579014 = query.getOrDefault("prettyPrint")
  valid_579014 = validateParameter(valid_579014, JBool, required = false,
                                 default = newJBool(true))
  if valid_579014 != nil:
    section.add "prettyPrint", valid_579014
  var valid_579015 = query.getOrDefault("oauth_token")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "oauth_token", valid_579015
  var valid_579016 = query.getOrDefault("$.xgafv")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = newJString("1"))
  if valid_579016 != nil:
    section.add "$.xgafv", valid_579016
  var valid_579017 = query.getOrDefault("alt")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = newJString("json"))
  if valid_579017 != nil:
    section.add "alt", valid_579017
  var valid_579018 = query.getOrDefault("uploadType")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "uploadType", valid_579018
  var valid_579019 = query.getOrDefault("quotaUser")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "quotaUser", valid_579019
  var valid_579020 = query.getOrDefault("callback")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "callback", valid_579020
  var valid_579021 = query.getOrDefault("fields")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "fields", valid_579021
  var valid_579022 = query.getOrDefault("access_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "access_token", valid_579022
  var valid_579023 = query.getOrDefault("upload_protocol")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "upload_protocol", valid_579023
  var valid_579024 = query.getOrDefault("clientVersion")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "clientVersion", valid_579024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579025: Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_579008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets breakpoint information.
  ## 
  let valid = call_579025.validator(path, query, header, formData, body)
  let scheme = call_579025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579025.url(scheme.get, call_579025.host, call_579025.base,
                         call_579025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579025, url, valid)

proc call*(call_579026: Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_579008;
          breakpointId: string; debuggeeId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsGet
  ## Gets breakpoint information.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   breakpointId: string (required)
  ##               : ID of the breakpoint to get.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   debuggeeId: string (required)
  ##             : ID of the debuggee whose breakpoint to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: string
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var path_579027 = newJObject()
  var query_579028 = newJObject()
  add(query_579028, "key", newJString(key))
  add(query_579028, "prettyPrint", newJBool(prettyPrint))
  add(query_579028, "oauth_token", newJString(oauthToken))
  add(query_579028, "$.xgafv", newJString(Xgafv))
  add(path_579027, "breakpointId", newJString(breakpointId))
  add(query_579028, "alt", newJString(alt))
  add(query_579028, "uploadType", newJString(uploadType))
  add(query_579028, "quotaUser", newJString(quotaUser))
  add(path_579027, "debuggeeId", newJString(debuggeeId))
  add(query_579028, "callback", newJString(callback))
  add(query_579028, "fields", newJString(fields))
  add(query_579028, "access_token", newJString(accessToken))
  add(query_579028, "upload_protocol", newJString(uploadProtocol))
  add(query_579028, "clientVersion", newJString(clientVersion))
  result = call_579026.call(path_579027, query_579028, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsGet* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsGet_579008(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsGet",
    meth: HttpMethod.HttpGet, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/{breakpointId}",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsGet_579009,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsGet_579010,
    schemes: {Scheme.Https})
type
  Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_579029 = ref object of OpenApiRestCall_578339
proc url_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_579031(protocol: Scheme;
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

proc validate_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_579030(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the breakpoint from the debuggee.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   breakpointId: JString (required)
  ##               : ID of the breakpoint to delete.
  ##   debuggeeId: JString (required)
  ##             : ID of the debuggee whose breakpoint to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `breakpointId` field"
  var valid_579032 = path.getOrDefault("breakpointId")
  valid_579032 = validateParameter(valid_579032, JString, required = true,
                                 default = nil)
  if valid_579032 != nil:
    section.add "breakpointId", valid_579032
  var valid_579033 = path.getOrDefault("debuggeeId")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = nil)
  if valid_579033 != nil:
    section.add "debuggeeId", valid_579033
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: JString
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  section = newJObject()
  var valid_579034 = query.getOrDefault("key")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "key", valid_579034
  var valid_579035 = query.getOrDefault("prettyPrint")
  valid_579035 = validateParameter(valid_579035, JBool, required = false,
                                 default = newJBool(true))
  if valid_579035 != nil:
    section.add "prettyPrint", valid_579035
  var valid_579036 = query.getOrDefault("oauth_token")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "oauth_token", valid_579036
  var valid_579037 = query.getOrDefault("$.xgafv")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = newJString("1"))
  if valid_579037 != nil:
    section.add "$.xgafv", valid_579037
  var valid_579038 = query.getOrDefault("alt")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("json"))
  if valid_579038 != nil:
    section.add "alt", valid_579038
  var valid_579039 = query.getOrDefault("uploadType")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "uploadType", valid_579039
  var valid_579040 = query.getOrDefault("quotaUser")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "quotaUser", valid_579040
  var valid_579041 = query.getOrDefault("callback")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "callback", valid_579041
  var valid_579042 = query.getOrDefault("fields")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "fields", valid_579042
  var valid_579043 = query.getOrDefault("access_token")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "access_token", valid_579043
  var valid_579044 = query.getOrDefault("upload_protocol")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "upload_protocol", valid_579044
  var valid_579045 = query.getOrDefault("clientVersion")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "clientVersion", valid_579045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579046: Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_579029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the breakpoint from the debuggee.
  ## 
  let valid = call_579046.validator(path, query, header, formData, body)
  let scheme = call_579046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579046.url(scheme.get, call_579046.host, call_579046.base,
                         call_579046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579046, url, valid)

proc call*(call_579047: Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_579029;
          breakpointId: string; debuggeeId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; clientVersion: string = ""): Recallable =
  ## clouddebuggerDebuggerDebuggeesBreakpointsDelete
  ## Deletes the breakpoint from the debuggee.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   breakpointId: string (required)
  ##               : ID of the breakpoint to delete.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   debuggeeId: string (required)
  ##             : ID of the debuggee whose breakpoint to delete.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   clientVersion: string
  ##                : The client version making the call.
  ## Schema: `domain/type/version` (e.g., `google.com/intellij/v1`).
  var path_579048 = newJObject()
  var query_579049 = newJObject()
  add(query_579049, "key", newJString(key))
  add(query_579049, "prettyPrint", newJBool(prettyPrint))
  add(query_579049, "oauth_token", newJString(oauthToken))
  add(query_579049, "$.xgafv", newJString(Xgafv))
  add(path_579048, "breakpointId", newJString(breakpointId))
  add(query_579049, "alt", newJString(alt))
  add(query_579049, "uploadType", newJString(uploadType))
  add(query_579049, "quotaUser", newJString(quotaUser))
  add(path_579048, "debuggeeId", newJString(debuggeeId))
  add(query_579049, "callback", newJString(callback))
  add(query_579049, "fields", newJString(fields))
  add(query_579049, "access_token", newJString(accessToken))
  add(query_579049, "upload_protocol", newJString(uploadProtocol))
  add(query_579049, "clientVersion", newJString(clientVersion))
  result = call_579047.call(path_579048, query_579049, nil, nil, nil)

var clouddebuggerDebuggerDebuggeesBreakpointsDelete* = Call_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_579029(
    name: "clouddebuggerDebuggerDebuggeesBreakpointsDelete",
    meth: HttpMethod.HttpDelete, host: "clouddebugger.googleapis.com",
    route: "/v2/debugger/debuggees/{debuggeeId}/breakpoints/{breakpointId}",
    validator: validate_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_579030,
    base: "/", url: url_ClouddebuggerDebuggerDebuggeesBreakpointsDelete_579031,
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
