
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Stackdriver Trace
## version: v2
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
  Call_CloudtraceProjectsTracesSpansCreateSpan_597677 = ref object of OpenApiRestCall_597408
proc url_CloudtraceProjectsTracesSpansCreateSpan_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesSpansCreateSpan_597678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new span.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the span in the following format:
  ## 
  ##     projects/[PROJECT_ID]/traces/[TRACE_ID]/spans/SPAN_ID is a unique identifier for a trace within a project;
  ## it is a 32-character hexadecimal encoding of a 16-byte array.
  ## 
  ## [SPAN_ID] is a unique identifier for a span within a trace; it
  ## is a 16-character hexadecimal encoding of an 8-byte array.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597805 = path.getOrDefault("name")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "name", valid_597805
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
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("callback")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "callback", valid_597824
  var valid_597825 = query.getOrDefault("access_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "access_token", valid_597825
  var valid_597826 = query.getOrDefault("uploadType")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "uploadType", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("$.xgafv")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = newJString("1"))
  if valid_597828 != nil:
    section.add "$.xgafv", valid_597828
  var valid_597829 = query.getOrDefault("prettyPrint")
  valid_597829 = validateParameter(valid_597829, JBool, required = false,
                                 default = newJBool(true))
  if valid_597829 != nil:
    section.add "prettyPrint", valid_597829
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

proc call*(call_597853: Call_CloudtraceProjectsTracesSpansCreateSpan_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new span.
  ## 
  let valid = call_597853.validator(path, query, header, formData, body)
  let scheme = call_597853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597853.url(scheme.get, call_597853.host, call_597853.base,
                         call_597853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597853, url, valid)

proc call*(call_597924: Call_CloudtraceProjectsTracesSpansCreateSpan_597677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudtraceProjectsTracesSpansCreateSpan
  ## Creates a new span.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the span in the following format:
  ## 
  ##     projects/[PROJECT_ID]/traces/[TRACE_ID]/spans/SPAN_ID is a unique identifier for a trace within a project;
  ## it is a 32-character hexadecimal encoding of a 16-byte array.
  ## 
  ## [SPAN_ID] is a unique identifier for a span within a trace; it
  ## is a 16-character hexadecimal encoding of an 8-byte array.
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
  var path_597925 = newJObject()
  var query_597927 = newJObject()
  var body_597928 = newJObject()
  add(query_597927, "upload_protocol", newJString(uploadProtocol))
  add(query_597927, "fields", newJString(fields))
  add(query_597927, "quotaUser", newJString(quotaUser))
  add(path_597925, "name", newJString(name))
  add(query_597927, "alt", newJString(alt))
  add(query_597927, "oauth_token", newJString(oauthToken))
  add(query_597927, "callback", newJString(callback))
  add(query_597927, "access_token", newJString(accessToken))
  add(query_597927, "uploadType", newJString(uploadType))
  add(query_597927, "key", newJString(key))
  add(query_597927, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597928 = body
  add(query_597927, "prettyPrint", newJBool(prettyPrint))
  result = call_597924.call(path_597925, query_597927, nil, nil, body_597928)

var cloudtraceProjectsTracesSpansCreateSpan* = Call_CloudtraceProjectsTracesSpansCreateSpan_597677(
    name: "cloudtraceProjectsTracesSpansCreateSpan", meth: HttpMethod.HttpPost,
    host: "cloudtrace.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudtraceProjectsTracesSpansCreateSpan_597678, base: "/",
    url: url_CloudtraceProjectsTracesSpansCreateSpan_597679,
    schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsTracesBatchWrite_597967 = ref object of OpenApiRestCall_597408
proc url_CloudtraceProjectsTracesBatchWrite_597969(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/traces:batchWrite")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesBatchWrite_597968(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sends new spans to new or existing traces. You cannot update
  ## existing spans.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the project where the spans belong. The format is
  ## `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597970 = path.getOrDefault("name")
  valid_597970 = validateParameter(valid_597970, JString, required = true,
                                 default = nil)
  if valid_597970 != nil:
    section.add "name", valid_597970
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
  var valid_597971 = query.getOrDefault("upload_protocol")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "upload_protocol", valid_597971
  var valid_597972 = query.getOrDefault("fields")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "fields", valid_597972
  var valid_597973 = query.getOrDefault("quotaUser")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "quotaUser", valid_597973
  var valid_597974 = query.getOrDefault("alt")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = newJString("json"))
  if valid_597974 != nil:
    section.add "alt", valid_597974
  var valid_597975 = query.getOrDefault("oauth_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "oauth_token", valid_597975
  var valid_597976 = query.getOrDefault("callback")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "callback", valid_597976
  var valid_597977 = query.getOrDefault("access_token")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "access_token", valid_597977
  var valid_597978 = query.getOrDefault("uploadType")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "uploadType", valid_597978
  var valid_597979 = query.getOrDefault("key")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "key", valid_597979
  var valid_597980 = query.getOrDefault("$.xgafv")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = newJString("1"))
  if valid_597980 != nil:
    section.add "$.xgafv", valid_597980
  var valid_597981 = query.getOrDefault("prettyPrint")
  valid_597981 = validateParameter(valid_597981, JBool, required = false,
                                 default = newJBool(true))
  if valid_597981 != nil:
    section.add "prettyPrint", valid_597981
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

proc call*(call_597983: Call_CloudtraceProjectsTracesBatchWrite_597967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sends new spans to new or existing traces. You cannot update
  ## existing spans.
  ## 
  let valid = call_597983.validator(path, query, header, formData, body)
  let scheme = call_597983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597983.url(scheme.get, call_597983.host, call_597983.base,
                         call_597983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597983, url, valid)

proc call*(call_597984: Call_CloudtraceProjectsTracesBatchWrite_597967;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudtraceProjectsTracesBatchWrite
  ## Sends new spans to new or existing traces. You cannot update
  ## existing spans.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the project where the spans belong. The format is
  ## `projects/[PROJECT_ID]`.
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
  var path_597985 = newJObject()
  var query_597986 = newJObject()
  var body_597987 = newJObject()
  add(query_597986, "upload_protocol", newJString(uploadProtocol))
  add(query_597986, "fields", newJString(fields))
  add(query_597986, "quotaUser", newJString(quotaUser))
  add(path_597985, "name", newJString(name))
  add(query_597986, "alt", newJString(alt))
  add(query_597986, "oauth_token", newJString(oauthToken))
  add(query_597986, "callback", newJString(callback))
  add(query_597986, "access_token", newJString(accessToken))
  add(query_597986, "uploadType", newJString(uploadType))
  add(query_597986, "key", newJString(key))
  add(query_597986, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597987 = body
  add(query_597986, "prettyPrint", newJBool(prettyPrint))
  result = call_597984.call(path_597985, query_597986, nil, nil, body_597987)

var cloudtraceProjectsTracesBatchWrite* = Call_CloudtraceProjectsTracesBatchWrite_597967(
    name: "cloudtraceProjectsTracesBatchWrite", meth: HttpMethod.HttpPost,
    host: "cloudtrace.googleapis.com", route: "/v2/{name}/traces:batchWrite",
    validator: validate_CloudtraceProjectsTracesBatchWrite_597968, base: "/",
    url: url_CloudtraceProjectsTracesBatchWrite_597969, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
