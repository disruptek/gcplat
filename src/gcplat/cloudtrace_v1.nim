
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Stackdriver Trace
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Sends application trace data to Stackdriver Trace for viewing. Trace data is collected for all App Engine applications by default. Trace data from other applications can be provided using this API. This library is used to interact with the Trace API directly. If you are looking to instrument your application for Stackdriver Trace, we recommend using OpenCensus.
## 
## 
## https://cloud.google.com/trace
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
  gcpServiceName = "cloudtrace"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudtraceProjectsTracesList_578610 = ref object of OpenApiRestCall_578339
proc url_CloudtraceProjectsTracesList_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/traces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesList_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. ID of the Cloud project where the trace data is stored.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578738 = path.getOrDefault("projectId")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "projectId", valid_578738
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
  ##   pageSize: JInt
  ##           : Optional. Maximum number of traces to return. If not specified or <= 0, the
  ## implementation selects a reasonable value.  The implementation may
  ## return fewer traces than the requested page size.
  ##   startTime: JString
  ##            : Start of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional. Field used to sort the returned traces.
  ## Can be one of the following:
  ## 
  ## *   `trace_id`
  ## *   `name` (`name` field of root span in the trace)
  ## *   `duration` (difference between `end_time` and `start_time` fields of
  ##      the root span)
  ## *   `start` (`start_time` field of the root span)
  ## 
  ## Descending order can be specified by appending `desc` to the sort field
  ## (for example, `name desc`).
  ## 
  ## Only one sort field is permitted.
  ##   filter: JString
  ##         : Optional. A filter against labels for the request.
  ## 
  ## By default, searches use prefix matching. To specify exact match, prepend
  ## a plus symbol (`+`) to the search term.
  ## Multiple terms are ANDed. Syntax:
  ## 
  ## *   `root:NAME_PREFIX` or `NAME_PREFIX`: Return traces where any root
  ##     span starts with `NAME_PREFIX`.
  ## *   `+root:NAME` or `+NAME`: Return traces where any root span's name is
  ##     exactly `NAME`.
  ## *   `span:NAME_PREFIX`: Return traces where any span starts with
  ##     `NAME_PREFIX`.
  ## *   `+span:NAME`: Return traces where any span's name is exactly
  ##     `NAME`.
  ## *   `latency:DURATION`: Return traces whose overall latency is
  ##     greater or equal to than `DURATION`. Accepted units are nanoseconds
  ##     (`ns`), milliseconds (`ms`), and seconds (`s`). Default is `ms`. For
  ##     example, `latency:24ms` returns traces whose overall latency
  ##     is greater than or equal to 24 milliseconds.
  ## *   `label:LABEL_KEY`: Return all traces containing the specified
  ##     label key (exact match, case-sensitive) regardless of the key:value
  ##     pair's value (including empty values).
  ## *   `LABEL_KEY:VALUE_PREFIX`: Return all traces containing the specified
  ##     label key (exact match, case-sensitive) whose value starts with
  ##     `VALUE_PREFIX`. Both a key and a value must be specified.
  ## *   `+LABEL_KEY:VALUE`: Return all traces containing a key:value pair
  ##     exactly matching the specified text. Both a key and a value must be
  ##     specified.
  ## *   `method:VALUE`: Equivalent to `/http/method:VALUE`.
  ## *   `url:VALUE`: Equivalent to `/http/url:VALUE`.
  ##   pageToken: JString
  ##            : Token identifying the page of results to return. If provided, use the
  ## value of the `next_page_token` field from a previous request.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : Optional. Type of data returned for traces in the list. Default is
  ## `MINIMAL`.
  ##   endTime: JString
  ##          : End of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("pageSize")
  valid_578756 = validateParameter(valid_578756, JInt, required = false, default = nil)
  if valid_578756 != nil:
    section.add "pageSize", valid_578756
  var valid_578757 = query.getOrDefault("startTime")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "startTime", valid_578757
  var valid_578758 = query.getOrDefault("alt")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = newJString("json"))
  if valid_578758 != nil:
    section.add "alt", valid_578758
  var valid_578759 = query.getOrDefault("uploadType")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "uploadType", valid_578759
  var valid_578760 = query.getOrDefault("quotaUser")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "quotaUser", valid_578760
  var valid_578761 = query.getOrDefault("orderBy")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "orderBy", valid_578761
  var valid_578762 = query.getOrDefault("filter")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "filter", valid_578762
  var valid_578763 = query.getOrDefault("pageToken")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "pageToken", valid_578763
  var valid_578764 = query.getOrDefault("callback")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "callback", valid_578764
  var valid_578765 = query.getOrDefault("fields")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "fields", valid_578765
  var valid_578766 = query.getOrDefault("access_token")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "access_token", valid_578766
  var valid_578767 = query.getOrDefault("upload_protocol")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "upload_protocol", valid_578767
  var valid_578768 = query.getOrDefault("view")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = newJString("VIEW_TYPE_UNSPECIFIED"))
  if valid_578768 != nil:
    section.add "view", valid_578768
  var valid_578769 = query.getOrDefault("endTime")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "endTime", valid_578769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578792: Call_CloudtraceProjectsTracesList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  let valid = call_578792.validator(path, query, header, formData, body)
  let scheme = call_578792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578792.url(scheme.get, call_578792.host, call_578792.base,
                         call_578792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578792, url, valid)

proc call*(call_578863: Call_CloudtraceProjectsTracesList_578610;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          startTime: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; orderBy: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          view: string = "VIEW_TYPE_UNSPECIFIED"; endTime: string = ""): Recallable =
  ## cloudtraceProjectsTracesList
  ## Returns of a list of traces that match the specified filter conditions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. ID of the Cloud project where the trace data is stored.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. Maximum number of traces to return. If not specified or <= 0, the
  ## implementation selects a reasonable value.  The implementation may
  ## return fewer traces than the requested page size.
  ##   startTime: string
  ##            : Start of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional. Field used to sort the returned traces.
  ## Can be one of the following:
  ## 
  ## *   `trace_id`
  ## *   `name` (`name` field of root span in the trace)
  ## *   `duration` (difference between `end_time` and `start_time` fields of
  ##      the root span)
  ## *   `start` (`start_time` field of the root span)
  ## 
  ## Descending order can be specified by appending `desc` to the sort field
  ## (for example, `name desc`).
  ## 
  ## Only one sort field is permitted.
  ##   filter: string
  ##         : Optional. A filter against labels for the request.
  ## 
  ## By default, searches use prefix matching. To specify exact match, prepend
  ## a plus symbol (`+`) to the search term.
  ## Multiple terms are ANDed. Syntax:
  ## 
  ## *   `root:NAME_PREFIX` or `NAME_PREFIX`: Return traces where any root
  ##     span starts with `NAME_PREFIX`.
  ## *   `+root:NAME` or `+NAME`: Return traces where any root span's name is
  ##     exactly `NAME`.
  ## *   `span:NAME_PREFIX`: Return traces where any span starts with
  ##     `NAME_PREFIX`.
  ## *   `+span:NAME`: Return traces where any span's name is exactly
  ##     `NAME`.
  ## *   `latency:DURATION`: Return traces whose overall latency is
  ##     greater or equal to than `DURATION`. Accepted units are nanoseconds
  ##     (`ns`), milliseconds (`ms`), and seconds (`s`). Default is `ms`. For
  ##     example, `latency:24ms` returns traces whose overall latency
  ##     is greater than or equal to 24 milliseconds.
  ## *   `label:LABEL_KEY`: Return all traces containing the specified
  ##     label key (exact match, case-sensitive) regardless of the key:value
  ##     pair's value (including empty values).
  ## *   `LABEL_KEY:VALUE_PREFIX`: Return all traces containing the specified
  ##     label key (exact match, case-sensitive) whose value starts with
  ##     `VALUE_PREFIX`. Both a key and a value must be specified.
  ## *   `+LABEL_KEY:VALUE`: Return all traces containing a key:value pair
  ##     exactly matching the specified text. Both a key and a value must be
  ##     specified.
  ## *   `method:VALUE`: Equivalent to `/http/method:VALUE`.
  ## *   `url:VALUE`: Equivalent to `/http/url:VALUE`.
  ##   pageToken: string
  ##            : Token identifying the page of results to return. If provided, use the
  ## value of the `next_page_token` field from a previous request.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Optional. Type of data returned for traces in the list. Default is
  ## `MINIMAL`.
  ##   endTime: string
  ##          : End of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  var path_578864 = newJObject()
  var query_578866 = newJObject()
  add(query_578866, "key", newJString(key))
  add(query_578866, "prettyPrint", newJBool(prettyPrint))
  add(query_578866, "oauth_token", newJString(oauthToken))
  add(path_578864, "projectId", newJString(projectId))
  add(query_578866, "$.xgafv", newJString(Xgafv))
  add(query_578866, "pageSize", newJInt(pageSize))
  add(query_578866, "startTime", newJString(startTime))
  add(query_578866, "alt", newJString(alt))
  add(query_578866, "uploadType", newJString(uploadType))
  add(query_578866, "quotaUser", newJString(quotaUser))
  add(query_578866, "orderBy", newJString(orderBy))
  add(query_578866, "filter", newJString(filter))
  add(query_578866, "pageToken", newJString(pageToken))
  add(query_578866, "callback", newJString(callback))
  add(query_578866, "fields", newJString(fields))
  add(query_578866, "access_token", newJString(accessToken))
  add(query_578866, "upload_protocol", newJString(uploadProtocol))
  add(query_578866, "view", newJString(view))
  add(query_578866, "endTime", newJString(endTime))
  result = call_578863.call(path_578864, query_578866, nil, nil, nil)

var cloudtraceProjectsTracesList* = Call_CloudtraceProjectsTracesList_578610(
    name: "cloudtraceProjectsTracesList", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com", route: "/v1/projects/{projectId}/traces",
    validator: validate_CloudtraceProjectsTracesList_578611, base: "/",
    url: url_CloudtraceProjectsTracesList_578612, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsPatchTraces_578905 = ref object of OpenApiRestCall_578339
proc url_CloudtraceProjectsPatchTraces_578907(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/traces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsPatchTraces_578906(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sends new traces to Stackdriver Trace or updates existing traces. If the ID
  ## of a trace that you send matches that of an existing trace, any fields
  ## in the existing trace and its spans are overwritten by the provided values,
  ## and any new fields provided are merged with the existing trace data. If the
  ## ID does not match, a new trace is created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. ID of the Cloud project where the trace data is stored.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578908 = path.getOrDefault("projectId")
  valid_578908 = validateParameter(valid_578908, JString, required = true,
                                 default = nil)
  if valid_578908 != nil:
    section.add "projectId", valid_578908
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
  var valid_578909 = query.getOrDefault("key")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "key", valid_578909
  var valid_578910 = query.getOrDefault("prettyPrint")
  valid_578910 = validateParameter(valid_578910, JBool, required = false,
                                 default = newJBool(true))
  if valid_578910 != nil:
    section.add "prettyPrint", valid_578910
  var valid_578911 = query.getOrDefault("oauth_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "oauth_token", valid_578911
  var valid_578912 = query.getOrDefault("$.xgafv")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = newJString("1"))
  if valid_578912 != nil:
    section.add "$.xgafv", valid_578912
  var valid_578913 = query.getOrDefault("alt")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = newJString("json"))
  if valid_578913 != nil:
    section.add "alt", valid_578913
  var valid_578914 = query.getOrDefault("uploadType")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "uploadType", valid_578914
  var valid_578915 = query.getOrDefault("quotaUser")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "quotaUser", valid_578915
  var valid_578916 = query.getOrDefault("callback")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "callback", valid_578916
  var valid_578917 = query.getOrDefault("fields")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "fields", valid_578917
  var valid_578918 = query.getOrDefault("access_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "access_token", valid_578918
  var valid_578919 = query.getOrDefault("upload_protocol")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "upload_protocol", valid_578919
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

proc call*(call_578921: Call_CloudtraceProjectsPatchTraces_578905; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends new traces to Stackdriver Trace or updates existing traces. If the ID
  ## of a trace that you send matches that of an existing trace, any fields
  ## in the existing trace and its spans are overwritten by the provided values,
  ## and any new fields provided are merged with the existing trace data. If the
  ## ID does not match, a new trace is created.
  ## 
  let valid = call_578921.validator(path, query, header, formData, body)
  let scheme = call_578921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578921.url(scheme.get, call_578921.host, call_578921.base,
                         call_578921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578921, url, valid)

proc call*(call_578922: Call_CloudtraceProjectsPatchTraces_578905;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudtraceProjectsPatchTraces
  ## Sends new traces to Stackdriver Trace or updates existing traces. If the ID
  ## of a trace that you send matches that of an existing trace, any fields
  ## in the existing trace and its spans are overwritten by the provided values,
  ## and any new fields provided are merged with the existing trace data. If the
  ## ID does not match, a new trace is created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. ID of the Cloud project where the trace data is stored.
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
  var path_578923 = newJObject()
  var query_578924 = newJObject()
  var body_578925 = newJObject()
  add(query_578924, "key", newJString(key))
  add(query_578924, "prettyPrint", newJBool(prettyPrint))
  add(query_578924, "oauth_token", newJString(oauthToken))
  add(path_578923, "projectId", newJString(projectId))
  add(query_578924, "$.xgafv", newJString(Xgafv))
  add(query_578924, "alt", newJString(alt))
  add(query_578924, "uploadType", newJString(uploadType))
  add(query_578924, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578925 = body
  add(query_578924, "callback", newJString(callback))
  add(query_578924, "fields", newJString(fields))
  add(query_578924, "access_token", newJString(accessToken))
  add(query_578924, "upload_protocol", newJString(uploadProtocol))
  result = call_578922.call(path_578923, query_578924, nil, nil, body_578925)

var cloudtraceProjectsPatchTraces* = Call_CloudtraceProjectsPatchTraces_578905(
    name: "cloudtraceProjectsPatchTraces", meth: HttpMethod.HttpPatch,
    host: "cloudtrace.googleapis.com", route: "/v1/projects/{projectId}/traces",
    validator: validate_CloudtraceProjectsPatchTraces_578906, base: "/",
    url: url_CloudtraceProjectsPatchTraces_578907, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsTracesGet_578926 = ref object of OpenApiRestCall_578339
proc url_CloudtraceProjectsTracesGet_578928(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "traceId" in path, "`traceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/traces/"),
               (kind: VariableSegment, value: "traceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesGet_578927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a single trace by its ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. ID of the Cloud project where the trace data is stored.
  ##   traceId: JString (required)
  ##          : Required. ID of the trace to return.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578929 = path.getOrDefault("projectId")
  valid_578929 = validateParameter(valid_578929, JString, required = true,
                                 default = nil)
  if valid_578929 != nil:
    section.add "projectId", valid_578929
  var valid_578930 = path.getOrDefault("traceId")
  valid_578930 = validateParameter(valid_578930, JString, required = true,
                                 default = nil)
  if valid_578930 != nil:
    section.add "traceId", valid_578930
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
  var valid_578931 = query.getOrDefault("key")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "key", valid_578931
  var valid_578932 = query.getOrDefault("prettyPrint")
  valid_578932 = validateParameter(valid_578932, JBool, required = false,
                                 default = newJBool(true))
  if valid_578932 != nil:
    section.add "prettyPrint", valid_578932
  var valid_578933 = query.getOrDefault("oauth_token")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "oauth_token", valid_578933
  var valid_578934 = query.getOrDefault("$.xgafv")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("1"))
  if valid_578934 != nil:
    section.add "$.xgafv", valid_578934
  var valid_578935 = query.getOrDefault("alt")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString("json"))
  if valid_578935 != nil:
    section.add "alt", valid_578935
  var valid_578936 = query.getOrDefault("uploadType")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "uploadType", valid_578936
  var valid_578937 = query.getOrDefault("quotaUser")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "quotaUser", valid_578937
  var valid_578938 = query.getOrDefault("callback")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "callback", valid_578938
  var valid_578939 = query.getOrDefault("fields")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "fields", valid_578939
  var valid_578940 = query.getOrDefault("access_token")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "access_token", valid_578940
  var valid_578941 = query.getOrDefault("upload_protocol")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "upload_protocol", valid_578941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578942: Call_CloudtraceProjectsTracesGet_578926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single trace by its ID.
  ## 
  let valid = call_578942.validator(path, query, header, formData, body)
  let scheme = call_578942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578942.url(scheme.get, call_578942.host, call_578942.base,
                         call_578942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578942, url, valid)

proc call*(call_578943: Call_CloudtraceProjectsTracesGet_578926; projectId: string;
          traceId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudtraceProjectsTracesGet
  ## Gets a single trace by its ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. ID of the Cloud project where the trace data is stored.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   traceId: string (required)
  ##          : Required. ID of the trace to return.
  var path_578944 = newJObject()
  var query_578945 = newJObject()
  add(query_578945, "key", newJString(key))
  add(query_578945, "prettyPrint", newJBool(prettyPrint))
  add(query_578945, "oauth_token", newJString(oauthToken))
  add(path_578944, "projectId", newJString(projectId))
  add(query_578945, "$.xgafv", newJString(Xgafv))
  add(query_578945, "alt", newJString(alt))
  add(query_578945, "uploadType", newJString(uploadType))
  add(query_578945, "quotaUser", newJString(quotaUser))
  add(query_578945, "callback", newJString(callback))
  add(query_578945, "fields", newJString(fields))
  add(query_578945, "access_token", newJString(accessToken))
  add(query_578945, "upload_protocol", newJString(uploadProtocol))
  add(path_578944, "traceId", newJString(traceId))
  result = call_578943.call(path_578944, query_578945, nil, nil, nil)

var cloudtraceProjectsTracesGet* = Call_CloudtraceProjectsTracesGet_578926(
    name: "cloudtraceProjectsTracesGet", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com",
    route: "/v1/projects/{projectId}/traces/{traceId}",
    validator: validate_CloudtraceProjectsTracesGet_578927, base: "/",
    url: url_CloudtraceProjectsTracesGet_578928, schemes: {Scheme.Https})
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
