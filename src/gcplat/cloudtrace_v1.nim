
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "cloudtrace"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudtraceProjectsTracesList_597677 = ref object of OpenApiRestCall_597408
proc url_CloudtraceProjectsTracesList_597679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtraceProjectsTracesList_597678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the Cloud project where the trace data is stored.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_597805 = path.getOrDefault("projectId")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "projectId", valid_597805
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token identifying the page of results to return. If provided, use the
  ## value of the `next_page_token` field from a previous request. Optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Type of data returned for traces in the list. Optional. Default is
  ## `MINIMAL`.
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
  ##   endTime: JString
  ##          : End of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   orderBy: JString
  ##          : Field used to sort the returned traces. Optional.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of traces to return. If not specified or <= 0, the
  ## implementation selects a reasonable value.  The implementation may
  ## return fewer traces than the requested page size. Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : Start of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   filter: JString
  ##         : An optional filter against labels for the request.
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
  section = newJObject()
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("pageToken")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "pageToken", valid_597808
  var valid_597809 = query.getOrDefault("quotaUser")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "quotaUser", valid_597809
  var valid_597823 = query.getOrDefault("view")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = newJString("VIEW_TYPE_UNSPECIFIED"))
  if valid_597823 != nil:
    section.add "view", valid_597823
  var valid_597824 = query.getOrDefault("alt")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = newJString("json"))
  if valid_597824 != nil:
    section.add "alt", valid_597824
  var valid_597825 = query.getOrDefault("oauth_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "oauth_token", valid_597825
  var valid_597826 = query.getOrDefault("callback")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "callback", valid_597826
  var valid_597827 = query.getOrDefault("access_token")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "access_token", valid_597827
  var valid_597828 = query.getOrDefault("uploadType")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = nil)
  if valid_597828 != nil:
    section.add "uploadType", valid_597828
  var valid_597829 = query.getOrDefault("endTime")
  valid_597829 = validateParameter(valid_597829, JString, required = false,
                                 default = nil)
  if valid_597829 != nil:
    section.add "endTime", valid_597829
  var valid_597830 = query.getOrDefault("orderBy")
  valid_597830 = validateParameter(valid_597830, JString, required = false,
                                 default = nil)
  if valid_597830 != nil:
    section.add "orderBy", valid_597830
  var valid_597831 = query.getOrDefault("key")
  valid_597831 = validateParameter(valid_597831, JString, required = false,
                                 default = nil)
  if valid_597831 != nil:
    section.add "key", valid_597831
  var valid_597832 = query.getOrDefault("$.xgafv")
  valid_597832 = validateParameter(valid_597832, JString, required = false,
                                 default = newJString("1"))
  if valid_597832 != nil:
    section.add "$.xgafv", valid_597832
  var valid_597833 = query.getOrDefault("pageSize")
  valid_597833 = validateParameter(valid_597833, JInt, required = false, default = nil)
  if valid_597833 != nil:
    section.add "pageSize", valid_597833
  var valid_597834 = query.getOrDefault("prettyPrint")
  valid_597834 = validateParameter(valid_597834, JBool, required = false,
                                 default = newJBool(true))
  if valid_597834 != nil:
    section.add "prettyPrint", valid_597834
  var valid_597835 = query.getOrDefault("startTime")
  valid_597835 = validateParameter(valid_597835, JString, required = false,
                                 default = nil)
  if valid_597835 != nil:
    section.add "startTime", valid_597835
  var valid_597836 = query.getOrDefault("filter")
  valid_597836 = validateParameter(valid_597836, JString, required = false,
                                 default = nil)
  if valid_597836 != nil:
    section.add "filter", valid_597836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597859: Call_CloudtraceProjectsTracesList_597677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  let valid = call_597859.validator(path, query, header, formData, body)
  let scheme = call_597859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597859.url(scheme.get, call_597859.host, call_597859.base,
                         call_597859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597859, url, valid)

proc call*(call_597930: Call_CloudtraceProjectsTracesList_597677;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = "";
          view: string = "VIEW_TYPE_UNSPECIFIED"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; endTime: string = ""; orderBy: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; startTime: string = ""; filter: string = ""): Recallable =
  ## cloudtraceProjectsTracesList
  ## Returns of a list of traces that match the specified filter conditions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token identifying the page of results to return. If provided, use the
  ## value of the `next_page_token` field from a previous request. Optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Type of data returned for traces in the list. Optional. Default is
  ## `MINIMAL`.
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
  ##   endTime: string
  ##          : End of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   orderBy: string
  ##          : Field used to sort the returned traces. Optional.
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the Cloud project where the trace data is stored.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of traces to return. If not specified or <= 0, the
  ## implementation selects a reasonable value.  The implementation may
  ## return fewer traces than the requested page size. Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : Start of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   filter: string
  ##         : An optional filter against labels for the request.
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
  var path_597931 = newJObject()
  var query_597933 = newJObject()
  add(query_597933, "upload_protocol", newJString(uploadProtocol))
  add(query_597933, "fields", newJString(fields))
  add(query_597933, "pageToken", newJString(pageToken))
  add(query_597933, "quotaUser", newJString(quotaUser))
  add(query_597933, "view", newJString(view))
  add(query_597933, "alt", newJString(alt))
  add(query_597933, "oauth_token", newJString(oauthToken))
  add(query_597933, "callback", newJString(callback))
  add(query_597933, "access_token", newJString(accessToken))
  add(query_597933, "uploadType", newJString(uploadType))
  add(query_597933, "endTime", newJString(endTime))
  add(query_597933, "orderBy", newJString(orderBy))
  add(query_597933, "key", newJString(key))
  add(path_597931, "projectId", newJString(projectId))
  add(query_597933, "$.xgafv", newJString(Xgafv))
  add(query_597933, "pageSize", newJInt(pageSize))
  add(query_597933, "prettyPrint", newJBool(prettyPrint))
  add(query_597933, "startTime", newJString(startTime))
  add(query_597933, "filter", newJString(filter))
  result = call_597930.call(path_597931, query_597933, nil, nil, nil)

var cloudtraceProjectsTracesList* = Call_CloudtraceProjectsTracesList_597677(
    name: "cloudtraceProjectsTracesList", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com", route: "/v1/projects/{projectId}/traces",
    validator: validate_CloudtraceProjectsTracesList_597678, base: "/",
    url: url_CloudtraceProjectsTracesList_597679, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsPatchTraces_597972 = ref object of OpenApiRestCall_597408
proc url_CloudtraceProjectsPatchTraces_597974(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtraceProjectsPatchTraces_597973(path: JsonNode; query: JsonNode;
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
  ##            : ID of the Cloud project where the trace data is stored.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_597975 = path.getOrDefault("projectId")
  valid_597975 = validateParameter(valid_597975, JString, required = true,
                                 default = nil)
  if valid_597975 != nil:
    section.add "projectId", valid_597975
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
  var valid_597976 = query.getOrDefault("upload_protocol")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "upload_protocol", valid_597976
  var valid_597977 = query.getOrDefault("fields")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "fields", valid_597977
  var valid_597978 = query.getOrDefault("quotaUser")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "quotaUser", valid_597978
  var valid_597979 = query.getOrDefault("alt")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = newJString("json"))
  if valid_597979 != nil:
    section.add "alt", valid_597979
  var valid_597980 = query.getOrDefault("oauth_token")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "oauth_token", valid_597980
  var valid_597981 = query.getOrDefault("callback")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "callback", valid_597981
  var valid_597982 = query.getOrDefault("access_token")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "access_token", valid_597982
  var valid_597983 = query.getOrDefault("uploadType")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "uploadType", valid_597983
  var valid_597984 = query.getOrDefault("key")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "key", valid_597984
  var valid_597985 = query.getOrDefault("$.xgafv")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = newJString("1"))
  if valid_597985 != nil:
    section.add "$.xgafv", valid_597985
  var valid_597986 = query.getOrDefault("prettyPrint")
  valid_597986 = validateParameter(valid_597986, JBool, required = false,
                                 default = newJBool(true))
  if valid_597986 != nil:
    section.add "prettyPrint", valid_597986
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

proc call*(call_597988: Call_CloudtraceProjectsPatchTraces_597972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends new traces to Stackdriver Trace or updates existing traces. If the ID
  ## of a trace that you send matches that of an existing trace, any fields
  ## in the existing trace and its spans are overwritten by the provided values,
  ## and any new fields provided are merged with the existing trace data. If the
  ## ID does not match, a new trace is created.
  ## 
  let valid = call_597988.validator(path, query, header, formData, body)
  let scheme = call_597988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597988.url(scheme.get, call_597988.host, call_597988.base,
                         call_597988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597988, url, valid)

proc call*(call_597989: Call_CloudtraceProjectsPatchTraces_597972;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudtraceProjectsPatchTraces
  ## Sends new traces to Stackdriver Trace or updates existing traces. If the ID
  ## of a trace that you send matches that of an existing trace, any fields
  ## in the existing trace and its spans are overwritten by the provided values,
  ## and any new fields provided are merged with the existing trace data. If the
  ## ID does not match, a new trace is created.
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
  ##   projectId: string (required)
  ##            : ID of the Cloud project where the trace data is stored.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597990 = newJObject()
  var query_597991 = newJObject()
  var body_597992 = newJObject()
  add(query_597991, "upload_protocol", newJString(uploadProtocol))
  add(query_597991, "fields", newJString(fields))
  add(query_597991, "quotaUser", newJString(quotaUser))
  add(query_597991, "alt", newJString(alt))
  add(query_597991, "oauth_token", newJString(oauthToken))
  add(query_597991, "callback", newJString(callback))
  add(query_597991, "access_token", newJString(accessToken))
  add(query_597991, "uploadType", newJString(uploadType))
  add(query_597991, "key", newJString(key))
  add(path_597990, "projectId", newJString(projectId))
  add(query_597991, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597992 = body
  add(query_597991, "prettyPrint", newJBool(prettyPrint))
  result = call_597989.call(path_597990, query_597991, nil, nil, body_597992)

var cloudtraceProjectsPatchTraces* = Call_CloudtraceProjectsPatchTraces_597972(
    name: "cloudtraceProjectsPatchTraces", meth: HttpMethod.HttpPatch,
    host: "cloudtrace.googleapis.com", route: "/v1/projects/{projectId}/traces",
    validator: validate_CloudtraceProjectsPatchTraces_597973, base: "/",
    url: url_CloudtraceProjectsPatchTraces_597974, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsTracesGet_597993 = ref object of OpenApiRestCall_597408
proc url_CloudtraceProjectsTracesGet_597995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudtraceProjectsTracesGet_597994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a single trace by its ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   traceId: JString (required)
  ##          : ID of the trace to return.
  ##   projectId: JString (required)
  ##            : ID of the Cloud project where the trace data is stored.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `traceId` field"
  var valid_597996 = path.getOrDefault("traceId")
  valid_597996 = validateParameter(valid_597996, JString, required = true,
                                 default = nil)
  if valid_597996 != nil:
    section.add "traceId", valid_597996
  var valid_597997 = path.getOrDefault("projectId")
  valid_597997 = validateParameter(valid_597997, JString, required = true,
                                 default = nil)
  if valid_597997 != nil:
    section.add "projectId", valid_597997
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
  var valid_597998 = query.getOrDefault("upload_protocol")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "upload_protocol", valid_597998
  var valid_597999 = query.getOrDefault("fields")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "fields", valid_597999
  var valid_598000 = query.getOrDefault("quotaUser")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "quotaUser", valid_598000
  var valid_598001 = query.getOrDefault("alt")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = newJString("json"))
  if valid_598001 != nil:
    section.add "alt", valid_598001
  var valid_598002 = query.getOrDefault("oauth_token")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "oauth_token", valid_598002
  var valid_598003 = query.getOrDefault("callback")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "callback", valid_598003
  var valid_598004 = query.getOrDefault("access_token")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "access_token", valid_598004
  var valid_598005 = query.getOrDefault("uploadType")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "uploadType", valid_598005
  var valid_598006 = query.getOrDefault("key")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "key", valid_598006
  var valid_598007 = query.getOrDefault("$.xgafv")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = newJString("1"))
  if valid_598007 != nil:
    section.add "$.xgafv", valid_598007
  var valid_598008 = query.getOrDefault("prettyPrint")
  valid_598008 = validateParameter(valid_598008, JBool, required = false,
                                 default = newJBool(true))
  if valid_598008 != nil:
    section.add "prettyPrint", valid_598008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598009: Call_CloudtraceProjectsTracesGet_597993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single trace by its ID.
  ## 
  let valid = call_598009.validator(path, query, header, formData, body)
  let scheme = call_598009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598009.url(scheme.get, call_598009.host, call_598009.base,
                         call_598009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598009, url, valid)

proc call*(call_598010: Call_CloudtraceProjectsTracesGet_597993; traceId: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudtraceProjectsTracesGet
  ## Gets a single trace by its ID.
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
  ##   traceId: string (required)
  ##          : ID of the trace to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the Cloud project where the trace data is stored.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598011 = newJObject()
  var query_598012 = newJObject()
  add(query_598012, "upload_protocol", newJString(uploadProtocol))
  add(query_598012, "fields", newJString(fields))
  add(query_598012, "quotaUser", newJString(quotaUser))
  add(query_598012, "alt", newJString(alt))
  add(query_598012, "oauth_token", newJString(oauthToken))
  add(query_598012, "callback", newJString(callback))
  add(query_598012, "access_token", newJString(accessToken))
  add(query_598012, "uploadType", newJString(uploadType))
  add(path_598011, "traceId", newJString(traceId))
  add(query_598012, "key", newJString(key))
  add(path_598011, "projectId", newJString(projectId))
  add(query_598012, "$.xgafv", newJString(Xgafv))
  add(query_598012, "prettyPrint", newJBool(prettyPrint))
  result = call_598010.call(path_598011, query_598012, nil, nil, nil)

var cloudtraceProjectsTracesGet* = Call_CloudtraceProjectsTracesGet_597993(
    name: "cloudtraceProjectsTracesGet", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com",
    route: "/v1/projects/{projectId}/traces/{traceId}",
    validator: validate_CloudtraceProjectsTracesGet_597994, base: "/",
    url: url_CloudtraceProjectsTracesGet_597995, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
