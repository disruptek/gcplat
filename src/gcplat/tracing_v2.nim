
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Stackdriver Trace
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Send and retrieve trace data from Stackdriver Trace. Data is generated and available by default for all App Engine applications. Data from other applications can be written to Stackdriver Trace for display, reporting, and analysis.
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
  gcpServiceName = "tracing"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudtraceProjectsTracesSpansCreate_578610 = ref object of OpenApiRestCall_578339
proc url_CloudtraceProjectsTracesSpansCreate_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesSpansCreate_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Span.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the span in the following format:
  ## 
  ##     projects/[PROJECT_ID]traces/[TRACE_ID]/spans/SPAN_ID is a unique identifier for a trace within a project.
  ## [SPAN_ID] is a unique identifier for a span within a trace,
  ## assigned when the span is created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("pp")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "pp", valid_578753
  var valid_578754 = query.getOrDefault("prettyPrint")
  valid_578754 = validateParameter(valid_578754, JBool, required = false,
                                 default = newJBool(true))
  if valid_578754 != nil:
    section.add "prettyPrint", valid_578754
  var valid_578755 = query.getOrDefault("oauth_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "oauth_token", valid_578755
  var valid_578756 = query.getOrDefault("$.xgafv")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("1"))
  if valid_578756 != nil:
    section.add "$.xgafv", valid_578756
  var valid_578757 = query.getOrDefault("bearer_token")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "bearer_token", valid_578757
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
  var valid_578761 = query.getOrDefault("callback")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "callback", valid_578761
  var valid_578762 = query.getOrDefault("fields")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "fields", valid_578762
  var valid_578763 = query.getOrDefault("access_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "access_token", valid_578763
  var valid_578764 = query.getOrDefault("upload_protocol")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "upload_protocol", valid_578764
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

proc call*(call_578788: Call_CloudtraceProjectsTracesSpansCreate_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Span.
  ## 
  let valid = call_578788.validator(path, query, header, formData, body)
  let scheme = call_578788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578788.url(scheme.get, call_578788.host, call_578788.base,
                         call_578788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578788, url, valid)

proc call*(call_578859: Call_CloudtraceProjectsTracesSpansCreate_578610;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudtraceProjectsTracesSpansCreate
  ## Creates a new Span.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the span in the following format:
  ## 
  ##     projects/[PROJECT_ID]traces/[TRACE_ID]/spans/SPAN_ID is a unique identifier for a trace within a project.
  ## [SPAN_ID] is a unique identifier for a span within a trace,
  ## assigned when the span is created.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578860 = newJObject()
  var query_578862 = newJObject()
  var body_578863 = newJObject()
  add(query_578862, "key", newJString(key))
  add(query_578862, "pp", newJBool(pp))
  add(query_578862, "prettyPrint", newJBool(prettyPrint))
  add(query_578862, "oauth_token", newJString(oauthToken))
  add(query_578862, "$.xgafv", newJString(Xgafv))
  add(query_578862, "bearer_token", newJString(bearerToken))
  add(query_578862, "alt", newJString(alt))
  add(query_578862, "uploadType", newJString(uploadType))
  add(query_578862, "quotaUser", newJString(quotaUser))
  add(path_578860, "name", newJString(name))
  if body != nil:
    body_578863 = body
  add(query_578862, "callback", newJString(callback))
  add(query_578862, "fields", newJString(fields))
  add(query_578862, "access_token", newJString(accessToken))
  add(query_578862, "upload_protocol", newJString(uploadProtocol))
  result = call_578859.call(path_578860, query_578862, nil, nil, body_578863)

var cloudtraceProjectsTracesSpansCreate* = Call_CloudtraceProjectsTracesSpansCreate_578610(
    name: "cloudtraceProjectsTracesSpansCreate", meth: HttpMethod.HttpPut,
    host: "cloudtrace.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudtraceProjectsTracesSpansCreate_578611, base: "/",
    url: url_CloudtraceProjectsTracesSpansCreate_578612, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsTracesBatchWrite_578902 = ref object of OpenApiRestCall_578339
proc url_CloudtraceProjectsTracesBatchWrite_578904(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudtraceProjectsTracesBatchWrite_578903(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sends new spans to Stackdriver Trace or updates existing traces. If the
  ## name of a trace that you send matches that of an existing trace, new spans
  ## are added to the existing trace. Attempt to update existing spans results
  ## undefined behavior. If the name does not match, a new trace is created
  ## with given set of spans.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Name of the project where the spans belong. The format is
  ## `projects/PROJECT_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578905 = path.getOrDefault("name")
  valid_578905 = validateParameter(valid_578905, JString, required = true,
                                 default = nil)
  if valid_578905 != nil:
    section.add "name", valid_578905
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578906 = query.getOrDefault("key")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "key", valid_578906
  var valid_578907 = query.getOrDefault("pp")
  valid_578907 = validateParameter(valid_578907, JBool, required = false,
                                 default = newJBool(true))
  if valid_578907 != nil:
    section.add "pp", valid_578907
  var valid_578908 = query.getOrDefault("prettyPrint")
  valid_578908 = validateParameter(valid_578908, JBool, required = false,
                                 default = newJBool(true))
  if valid_578908 != nil:
    section.add "prettyPrint", valid_578908
  var valid_578909 = query.getOrDefault("oauth_token")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "oauth_token", valid_578909
  var valid_578910 = query.getOrDefault("$.xgafv")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = newJString("1"))
  if valid_578910 != nil:
    section.add "$.xgafv", valid_578910
  var valid_578911 = query.getOrDefault("bearer_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "bearer_token", valid_578911
  var valid_578912 = query.getOrDefault("alt")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = newJString("json"))
  if valid_578912 != nil:
    section.add "alt", valid_578912
  var valid_578913 = query.getOrDefault("uploadType")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "uploadType", valid_578913
  var valid_578914 = query.getOrDefault("quotaUser")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "quotaUser", valid_578914
  var valid_578915 = query.getOrDefault("callback")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "callback", valid_578915
  var valid_578916 = query.getOrDefault("fields")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "fields", valid_578916
  var valid_578917 = query.getOrDefault("access_token")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "access_token", valid_578917
  var valid_578918 = query.getOrDefault("upload_protocol")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "upload_protocol", valid_578918
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

proc call*(call_578920: Call_CloudtraceProjectsTracesBatchWrite_578902;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sends new spans to Stackdriver Trace or updates existing traces. If the
  ## name of a trace that you send matches that of an existing trace, new spans
  ## are added to the existing trace. Attempt to update existing spans results
  ## undefined behavior. If the name does not match, a new trace is created
  ## with given set of spans.
  ## 
  let valid = call_578920.validator(path, query, header, formData, body)
  let scheme = call_578920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578920.url(scheme.get, call_578920.host, call_578920.base,
                         call_578920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578920, url, valid)

proc call*(call_578921: Call_CloudtraceProjectsTracesBatchWrite_578902;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudtraceProjectsTracesBatchWrite
  ## Sends new spans to Stackdriver Trace or updates existing traces. If the
  ## name of a trace that you send matches that of an existing trace, new spans
  ## are added to the existing trace. Attempt to update existing spans results
  ## undefined behavior. If the name does not match, a new trace is created
  ## with given set of spans.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Name of the project where the spans belong. The format is
  ## `projects/PROJECT_ID`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578922 = newJObject()
  var query_578923 = newJObject()
  var body_578924 = newJObject()
  add(query_578923, "key", newJString(key))
  add(query_578923, "pp", newJBool(pp))
  add(query_578923, "prettyPrint", newJBool(prettyPrint))
  add(query_578923, "oauth_token", newJString(oauthToken))
  add(query_578923, "$.xgafv", newJString(Xgafv))
  add(query_578923, "bearer_token", newJString(bearerToken))
  add(query_578923, "alt", newJString(alt))
  add(query_578923, "uploadType", newJString(uploadType))
  add(query_578923, "quotaUser", newJString(quotaUser))
  add(path_578922, "name", newJString(name))
  if body != nil:
    body_578924 = body
  add(query_578923, "callback", newJString(callback))
  add(query_578923, "fields", newJString(fields))
  add(query_578923, "access_token", newJString(accessToken))
  add(query_578923, "upload_protocol", newJString(uploadProtocol))
  result = call_578921.call(path_578922, query_578923, nil, nil, body_578924)

var cloudtraceProjectsTracesBatchWrite* = Call_CloudtraceProjectsTracesBatchWrite_578902(
    name: "cloudtraceProjectsTracesBatchWrite", meth: HttpMethod.HttpPost,
    host: "cloudtrace.googleapis.com", route: "/v2/{name}/traces:batchWrite",
    validator: validate_CloudtraceProjectsTracesBatchWrite_578903, base: "/",
    url: url_CloudtraceProjectsTracesBatchWrite_578904, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsTracesList_578925 = ref object of OpenApiRestCall_578339
proc url_CloudtraceProjectsTracesList_578927(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/traces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesList_578926(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project where the trace data is stored. The format
  ## is `projects/PROJECT_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578928 = path.getOrDefault("parent")
  valid_578928 = validateParameter(valid_578928, JString, required = true,
                                 default = nil)
  if valid_578928 != nil:
    section.add "parent", valid_578928
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request.
  ## Non-positive values are ignored. The presence of `next_page_token` in the
  ## response indicates that more results might be available, even if fewer than
  ## the maximum number of results is returned by this request.
  ##   startTime: JString
  ##            : Optional. Do not return traces whose end time is earlier than this time.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional. A single field used to sort the returned traces.
  ## Only the following field names can be used:
  ## 
  ## *   `trace_id`: the trace's ID field
  ## *   `name`:  the root span's resource name
  ## *   `duration`: the difference between the root span's start time and end time
  ## *   `start`:  the start time of the root span
  ## 
  ## Sorting is in ascending order unless `desc` is appended to the sort field name.
  ## Example: `"name desc"`).
  ##   filter: JString
  ##         : Opional. Return only traces that match this
  ## [trace filter](/trace/docs/trace-filters). Example:
  ## 
  ##     "label:/http/url root:/_ah/background my_label:17"
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the
  ## preceding call to this method.  `page_token` must be the value of
  ## `next_page_token` from the previous response.  The values of other method
  ## parameters should be identical to those in the previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   endTime: JString
  ##          : Optional. Do not return traces whose start time is later than this time.
  section = newJObject()
  var valid_578929 = query.getOrDefault("key")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "key", valid_578929
  var valid_578930 = query.getOrDefault("pp")
  valid_578930 = validateParameter(valid_578930, JBool, required = false,
                                 default = newJBool(true))
  if valid_578930 != nil:
    section.add "pp", valid_578930
  var valid_578931 = query.getOrDefault("prettyPrint")
  valid_578931 = validateParameter(valid_578931, JBool, required = false,
                                 default = newJBool(true))
  if valid_578931 != nil:
    section.add "prettyPrint", valid_578931
  var valid_578932 = query.getOrDefault("oauth_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "oauth_token", valid_578932
  var valid_578933 = query.getOrDefault("$.xgafv")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("1"))
  if valid_578933 != nil:
    section.add "$.xgafv", valid_578933
  var valid_578934 = query.getOrDefault("bearer_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "bearer_token", valid_578934
  var valid_578935 = query.getOrDefault("pageSize")
  valid_578935 = validateParameter(valid_578935, JInt, required = false, default = nil)
  if valid_578935 != nil:
    section.add "pageSize", valid_578935
  var valid_578936 = query.getOrDefault("startTime")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "startTime", valid_578936
  var valid_578937 = query.getOrDefault("alt")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("json"))
  if valid_578937 != nil:
    section.add "alt", valid_578937
  var valid_578938 = query.getOrDefault("uploadType")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "uploadType", valid_578938
  var valid_578939 = query.getOrDefault("quotaUser")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "quotaUser", valid_578939
  var valid_578940 = query.getOrDefault("orderBy")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "orderBy", valid_578940
  var valid_578941 = query.getOrDefault("filter")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "filter", valid_578941
  var valid_578942 = query.getOrDefault("pageToken")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "pageToken", valid_578942
  var valid_578943 = query.getOrDefault("callback")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "callback", valid_578943
  var valid_578944 = query.getOrDefault("fields")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "fields", valid_578944
  var valid_578945 = query.getOrDefault("access_token")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "access_token", valid_578945
  var valid_578946 = query.getOrDefault("upload_protocol")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "upload_protocol", valid_578946
  var valid_578947 = query.getOrDefault("endTime")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "endTime", valid_578947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578948: Call_CloudtraceProjectsTracesList_578925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  let valid = call_578948.validator(path, query, header, formData, body)
  let scheme = call_578948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578948.url(scheme.get, call_578948.host, call_578948.base,
                         call_578948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578948, url, valid)

proc call*(call_578949: Call_CloudtraceProjectsTracesList_578925; parent: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; startTime: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; orderBy: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          endTime: string = ""): Recallable =
  ## cloudtraceProjectsTracesList
  ## Returns of a list of traces that match the specified filter conditions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request.
  ## Non-positive values are ignored. The presence of `next_page_token` in the
  ## response indicates that more results might be available, even if fewer than
  ## the maximum number of results is returned by this request.
  ##   startTime: string
  ##            : Optional. Do not return traces whose end time is earlier than this time.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional. A single field used to sort the returned traces.
  ## Only the following field names can be used:
  ## 
  ## *   `trace_id`: the trace's ID field
  ## *   `name`:  the root span's resource name
  ## *   `duration`: the difference between the root span's start time and end time
  ## *   `start`:  the start time of the root span
  ## 
  ## Sorting is in ascending order unless `desc` is appended to the sort field name.
  ## Example: `"name desc"`).
  ##   filter: string
  ##         : Opional. Return only traces that match this
  ## [trace filter](/trace/docs/trace-filters). Example:
  ## 
  ##     "label:/http/url root:/_ah/background my_label:17"
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the
  ## preceding call to this method.  `page_token` must be the value of
  ## `next_page_token` from the previous response.  The values of other method
  ## parameters should be identical to those in the previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project where the trace data is stored. The format
  ## is `projects/PROJECT_ID`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   endTime: string
  ##          : Optional. Do not return traces whose start time is later than this time.
  var path_578950 = newJObject()
  var query_578951 = newJObject()
  add(query_578951, "key", newJString(key))
  add(query_578951, "pp", newJBool(pp))
  add(query_578951, "prettyPrint", newJBool(prettyPrint))
  add(query_578951, "oauth_token", newJString(oauthToken))
  add(query_578951, "$.xgafv", newJString(Xgafv))
  add(query_578951, "bearer_token", newJString(bearerToken))
  add(query_578951, "pageSize", newJInt(pageSize))
  add(query_578951, "startTime", newJString(startTime))
  add(query_578951, "alt", newJString(alt))
  add(query_578951, "uploadType", newJString(uploadType))
  add(query_578951, "quotaUser", newJString(quotaUser))
  add(query_578951, "orderBy", newJString(orderBy))
  add(query_578951, "filter", newJString(filter))
  add(query_578951, "pageToken", newJString(pageToken))
  add(query_578951, "callback", newJString(callback))
  add(path_578950, "parent", newJString(parent))
  add(query_578951, "fields", newJString(fields))
  add(query_578951, "access_token", newJString(accessToken))
  add(query_578951, "upload_protocol", newJString(uploadProtocol))
  add(query_578951, "endTime", newJString(endTime))
  result = call_578949.call(path_578950, query_578951, nil, nil, nil)

var cloudtraceProjectsTracesList* = Call_CloudtraceProjectsTracesList_578925(
    name: "cloudtraceProjectsTracesList", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com", route: "/v2/{parent}/traces",
    validator: validate_CloudtraceProjectsTracesList_578926, base: "/",
    url: url_CloudtraceProjectsTracesList_578927, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsTracesListSpans_578952 = ref object of OpenApiRestCall_578339
proc url_CloudtraceProjectsTracesListSpans_578954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":listSpans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesListSpans_578953(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of spans within a trace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required: The resource name of the trace containing the spans to list.
  ## The format is `projects/PROJECT_ID/traces/TRACE_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578955 = path.getOrDefault("parent")
  valid_578955 = validateParameter(valid_578955, JString, required = true,
                                 default = nil)
  if valid_578955 != nil:
    section.add "parent", valid_578955
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the
  ## preceding call to this method. `page_token` must be the value of
  ## `next_page_token` from the previous response. The values of other method
  ## parameters should be identical to those in the previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578956 = query.getOrDefault("key")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "key", valid_578956
  var valid_578957 = query.getOrDefault("pp")
  valid_578957 = validateParameter(valid_578957, JBool, required = false,
                                 default = newJBool(true))
  if valid_578957 != nil:
    section.add "pp", valid_578957
  var valid_578958 = query.getOrDefault("prettyPrint")
  valid_578958 = validateParameter(valid_578958, JBool, required = false,
                                 default = newJBool(true))
  if valid_578958 != nil:
    section.add "prettyPrint", valid_578958
  var valid_578959 = query.getOrDefault("oauth_token")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "oauth_token", valid_578959
  var valid_578960 = query.getOrDefault("$.xgafv")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = newJString("1"))
  if valid_578960 != nil:
    section.add "$.xgafv", valid_578960
  var valid_578961 = query.getOrDefault("bearer_token")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "bearer_token", valid_578961
  var valid_578962 = query.getOrDefault("alt")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = newJString("json"))
  if valid_578962 != nil:
    section.add "alt", valid_578962
  var valid_578963 = query.getOrDefault("uploadType")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "uploadType", valid_578963
  var valid_578964 = query.getOrDefault("quotaUser")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "quotaUser", valid_578964
  var valid_578965 = query.getOrDefault("pageToken")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "pageToken", valid_578965
  var valid_578966 = query.getOrDefault("callback")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "callback", valid_578966
  var valid_578967 = query.getOrDefault("fields")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "fields", valid_578967
  var valid_578968 = query.getOrDefault("access_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "access_token", valid_578968
  var valid_578969 = query.getOrDefault("upload_protocol")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "upload_protocol", valid_578969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578970: Call_CloudtraceProjectsTracesListSpans_578952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of spans within a trace.
  ## 
  let valid = call_578970.validator(path, query, header, formData, body)
  let scheme = call_578970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578970.url(scheme.get, call_578970.host, call_578970.base,
                         call_578970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578970, url, valid)

proc call*(call_578971: Call_CloudtraceProjectsTracesListSpans_578952;
          parent: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudtraceProjectsTracesListSpans
  ## Returns a list of spans within a trace.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the
  ## preceding call to this method. `page_token` must be the value of
  ## `next_page_token` from the previous response. The values of other method
  ## parameters should be identical to those in the previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required: The resource name of the trace containing the spans to list.
  ## The format is `projects/PROJECT_ID/traces/TRACE_ID`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578972 = newJObject()
  var query_578973 = newJObject()
  add(query_578973, "key", newJString(key))
  add(query_578973, "pp", newJBool(pp))
  add(query_578973, "prettyPrint", newJBool(prettyPrint))
  add(query_578973, "oauth_token", newJString(oauthToken))
  add(query_578973, "$.xgafv", newJString(Xgafv))
  add(query_578973, "bearer_token", newJString(bearerToken))
  add(query_578973, "alt", newJString(alt))
  add(query_578973, "uploadType", newJString(uploadType))
  add(query_578973, "quotaUser", newJString(quotaUser))
  add(query_578973, "pageToken", newJString(pageToken))
  add(query_578973, "callback", newJString(callback))
  add(path_578972, "parent", newJString(parent))
  add(query_578973, "fields", newJString(fields))
  add(query_578973, "access_token", newJString(accessToken))
  add(query_578973, "upload_protocol", newJString(uploadProtocol))
  result = call_578971.call(path_578972, query_578973, nil, nil, nil)

var cloudtraceProjectsTracesListSpans* = Call_CloudtraceProjectsTracesListSpans_578952(
    name: "cloudtraceProjectsTracesListSpans", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com", route: "/v2/{parent}:listSpans",
    validator: validate_CloudtraceProjectsTracesListSpans_578953, base: "/",
    url: url_CloudtraceProjectsTracesListSpans_578954, schemes: {Scheme.Https})
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
