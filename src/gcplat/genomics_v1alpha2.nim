
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Genomics
## version: v1alpha2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Uploads, processes, queries, and searches Genomics data in the cloud.
## 
## https://cloud.google.com/genomics
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
  gcpServiceName = "genomics"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GenomicsPipelinesCreate_578886 = ref object of OpenApiRestCall_578339
proc url_GenomicsPipelinesCreate_578888(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesCreate_578887(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a pipeline that can be run later. Create takes a Pipeline that
  ## has all fields other than `pipelineId` populated, and then returns
  ## the same pipeline with `pipelineId` populated. This id can be used
  ## to run the pipeline.
  ## 
  ## Caller must have WRITE permission to the project.
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
  var valid_578889 = query.getOrDefault("key")
  valid_578889 = validateParameter(valid_578889, JString, required = false,
                                 default = nil)
  if valid_578889 != nil:
    section.add "key", valid_578889
  var valid_578890 = query.getOrDefault("prettyPrint")
  valid_578890 = validateParameter(valid_578890, JBool, required = false,
                                 default = newJBool(true))
  if valid_578890 != nil:
    section.add "prettyPrint", valid_578890
  var valid_578891 = query.getOrDefault("oauth_token")
  valid_578891 = validateParameter(valid_578891, JString, required = false,
                                 default = nil)
  if valid_578891 != nil:
    section.add "oauth_token", valid_578891
  var valid_578892 = query.getOrDefault("$.xgafv")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = newJString("1"))
  if valid_578892 != nil:
    section.add "$.xgafv", valid_578892
  var valid_578893 = query.getOrDefault("alt")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = newJString("json"))
  if valid_578893 != nil:
    section.add "alt", valid_578893
  var valid_578894 = query.getOrDefault("uploadType")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "uploadType", valid_578894
  var valid_578895 = query.getOrDefault("quotaUser")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "quotaUser", valid_578895
  var valid_578896 = query.getOrDefault("callback")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "callback", valid_578896
  var valid_578897 = query.getOrDefault("fields")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "fields", valid_578897
  var valid_578898 = query.getOrDefault("access_token")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "access_token", valid_578898
  var valid_578899 = query.getOrDefault("upload_protocol")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "upload_protocol", valid_578899
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

proc call*(call_578901: Call_GenomicsPipelinesCreate_578886; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a pipeline that can be run later. Create takes a Pipeline that
  ## has all fields other than `pipelineId` populated, and then returns
  ## the same pipeline with `pipelineId` populated. This id can be used
  ## to run the pipeline.
  ## 
  ## Caller must have WRITE permission to the project.
  ## 
  let valid = call_578901.validator(path, query, header, formData, body)
  let scheme = call_578901.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578901.url(scheme.get, call_578901.host, call_578901.base,
                         call_578901.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578901, url, valid)

proc call*(call_578902: Call_GenomicsPipelinesCreate_578886; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## genomicsPipelinesCreate
  ## Creates a pipeline that can be run later. Create takes a Pipeline that
  ## has all fields other than `pipelineId` populated, and then returns
  ## the same pipeline with `pipelineId` populated. This id can be used
  ## to run the pipeline.
  ## 
  ## Caller must have WRITE permission to the project.
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
  var query_578903 = newJObject()
  var body_578904 = newJObject()
  add(query_578903, "key", newJString(key))
  add(query_578903, "prettyPrint", newJBool(prettyPrint))
  add(query_578903, "oauth_token", newJString(oauthToken))
  add(query_578903, "$.xgafv", newJString(Xgafv))
  add(query_578903, "alt", newJString(alt))
  add(query_578903, "uploadType", newJString(uploadType))
  add(query_578903, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578904 = body
  add(query_578903, "callback", newJString(callback))
  add(query_578903, "fields", newJString(fields))
  add(query_578903, "access_token", newJString(accessToken))
  add(query_578903, "upload_protocol", newJString(uploadProtocol))
  result = call_578902.call(nil, query_578903, nil, nil, body_578904)

var genomicsPipelinesCreate* = Call_GenomicsPipelinesCreate_578886(
    name: "genomicsPipelinesCreate", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines",
    validator: validate_GenomicsPipelinesCreate_578887, base: "/",
    url: url_GenomicsPipelinesCreate_578888, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesList_578610 = ref object of OpenApiRestCall_578339
proc url_GenomicsPipelinesList_578612(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesList_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists pipelines.
  ## 
  ## Caller must have READ permission to the project.
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
  ##   pageSize: JInt
  ##           : Number of pipelines to return at once. Defaults to 256, and max
  ## is 2048.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   namePrefix: JString
  ##             : Pipelines with names that match this prefix should be
  ## returned.  If unspecified, all pipelines in the project, up to
  ## `pageSize`, will be returned.
  ##   pageToken: JString
  ##            : Token to use to indicate where to start getting results.
  ## If unspecified, returns the first page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : Required. The name of the project to search for pipelines. Caller
  ## must have READ access to this project.
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
  var valid_578741 = query.getOrDefault("pageSize")
  valid_578741 = validateParameter(valid_578741, JInt, required = false, default = nil)
  if valid_578741 != nil:
    section.add "pageSize", valid_578741
  var valid_578742 = query.getOrDefault("alt")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = newJString("json"))
  if valid_578742 != nil:
    section.add "alt", valid_578742
  var valid_578743 = query.getOrDefault("uploadType")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "uploadType", valid_578743
  var valid_578744 = query.getOrDefault("quotaUser")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "quotaUser", valid_578744
  var valid_578745 = query.getOrDefault("namePrefix")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "namePrefix", valid_578745
  var valid_578746 = query.getOrDefault("pageToken")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "pageToken", valid_578746
  var valid_578747 = query.getOrDefault("callback")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "callback", valid_578747
  var valid_578748 = query.getOrDefault("fields")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "fields", valid_578748
  var valid_578749 = query.getOrDefault("access_token")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "access_token", valid_578749
  var valid_578750 = query.getOrDefault("upload_protocol")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "upload_protocol", valid_578750
  var valid_578751 = query.getOrDefault("projectId")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "projectId", valid_578751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578774: Call_GenomicsPipelinesList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pipelines.
  ## 
  ## Caller must have READ permission to the project.
  ## 
  let valid = call_578774.validator(path, query, header, formData, body)
  let scheme = call_578774.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578774.url(scheme.get, call_578774.host, call_578774.base,
                         call_578774.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578774, url, valid)

proc call*(call_578845: Call_GenomicsPipelinesList_578610; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; namePrefix: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## genomicsPipelinesList
  ## Lists pipelines.
  ## 
  ## Caller must have READ permission to the project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of pipelines to return at once. Defaults to 256, and max
  ## is 2048.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   namePrefix: string
  ##             : Pipelines with names that match this prefix should be
  ## returned.  If unspecified, all pipelines in the project, up to
  ## `pageSize`, will be returned.
  ##   pageToken: string
  ##            : Token to use to indicate where to start getting results.
  ## If unspecified, returns the first page of results.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : Required. The name of the project to search for pipelines. Caller
  ## must have READ access to this project.
  var query_578846 = newJObject()
  add(query_578846, "key", newJString(key))
  add(query_578846, "prettyPrint", newJBool(prettyPrint))
  add(query_578846, "oauth_token", newJString(oauthToken))
  add(query_578846, "$.xgafv", newJString(Xgafv))
  add(query_578846, "pageSize", newJInt(pageSize))
  add(query_578846, "alt", newJString(alt))
  add(query_578846, "uploadType", newJString(uploadType))
  add(query_578846, "quotaUser", newJString(quotaUser))
  add(query_578846, "namePrefix", newJString(namePrefix))
  add(query_578846, "pageToken", newJString(pageToken))
  add(query_578846, "callback", newJString(callback))
  add(query_578846, "fields", newJString(fields))
  add(query_578846, "access_token", newJString(accessToken))
  add(query_578846, "upload_protocol", newJString(uploadProtocol))
  add(query_578846, "projectId", newJString(projectId))
  result = call_578845.call(nil, query_578846, nil, nil, nil)

var genomicsPipelinesList* = Call_GenomicsPipelinesList_578610(
    name: "genomicsPipelinesList", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines",
    validator: validate_GenomicsPipelinesList_578611, base: "/",
    url: url_GenomicsPipelinesList_578612, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesGet_578905 = ref object of OpenApiRestCall_578339
proc url_GenomicsPipelinesGet_578907(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "pipelineId" in path, "`pipelineId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/pipelines/"),
               (kind: VariableSegment, value: "pipelineId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GenomicsPipelinesGet_578906(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a pipeline based on ID.
  ## 
  ## Caller must have READ permission to the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pipelineId: JString (required)
  ##             : Caller must have READ access to the project in which this pipeline
  ## is defined.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `pipelineId` field"
  var valid_578922 = path.getOrDefault("pipelineId")
  valid_578922 = validateParameter(valid_578922, JString, required = true,
                                 default = nil)
  if valid_578922 != nil:
    section.add "pipelineId", valid_578922
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
  var valid_578923 = query.getOrDefault("key")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "key", valid_578923
  var valid_578924 = query.getOrDefault("prettyPrint")
  valid_578924 = validateParameter(valid_578924, JBool, required = false,
                                 default = newJBool(true))
  if valid_578924 != nil:
    section.add "prettyPrint", valid_578924
  var valid_578925 = query.getOrDefault("oauth_token")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "oauth_token", valid_578925
  var valid_578926 = query.getOrDefault("$.xgafv")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("1"))
  if valid_578926 != nil:
    section.add "$.xgafv", valid_578926
  var valid_578927 = query.getOrDefault("alt")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = newJString("json"))
  if valid_578927 != nil:
    section.add "alt", valid_578927
  var valid_578928 = query.getOrDefault("uploadType")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "uploadType", valid_578928
  var valid_578929 = query.getOrDefault("quotaUser")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "quotaUser", valid_578929
  var valid_578930 = query.getOrDefault("callback")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "callback", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  var valid_578932 = query.getOrDefault("access_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "access_token", valid_578932
  var valid_578933 = query.getOrDefault("upload_protocol")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "upload_protocol", valid_578933
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578934: Call_GenomicsPipelinesGet_578905; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a pipeline based on ID.
  ## 
  ## Caller must have READ permission to the project.
  ## 
  let valid = call_578934.validator(path, query, header, formData, body)
  let scheme = call_578934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578934.url(scheme.get, call_578934.host, call_578934.base,
                         call_578934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578934, url, valid)

proc call*(call_578935: Call_GenomicsPipelinesGet_578905; pipelineId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## genomicsPipelinesGet
  ## Retrieves a pipeline based on ID.
  ## 
  ## Caller must have READ permission to the project.
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
  ##   callback: string
  ##           : JSONP
  ##   pipelineId: string (required)
  ##             : Caller must have READ access to the project in which this pipeline
  ## is defined.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578936 = newJObject()
  var query_578937 = newJObject()
  add(query_578937, "key", newJString(key))
  add(query_578937, "prettyPrint", newJBool(prettyPrint))
  add(query_578937, "oauth_token", newJString(oauthToken))
  add(query_578937, "$.xgafv", newJString(Xgafv))
  add(query_578937, "alt", newJString(alt))
  add(query_578937, "uploadType", newJString(uploadType))
  add(query_578937, "quotaUser", newJString(quotaUser))
  add(query_578937, "callback", newJString(callback))
  add(path_578936, "pipelineId", newJString(pipelineId))
  add(query_578937, "fields", newJString(fields))
  add(query_578937, "access_token", newJString(accessToken))
  add(query_578937, "upload_protocol", newJString(uploadProtocol))
  result = call_578935.call(path_578936, query_578937, nil, nil, nil)

var genomicsPipelinesGet* = Call_GenomicsPipelinesGet_578905(
    name: "genomicsPipelinesGet", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines/{pipelineId}",
    validator: validate_GenomicsPipelinesGet_578906, base: "/",
    url: url_GenomicsPipelinesGet_578907, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesDelete_578938 = ref object of OpenApiRestCall_578339
proc url_GenomicsPipelinesDelete_578940(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "pipelineId" in path, "`pipelineId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/pipelines/"),
               (kind: VariableSegment, value: "pipelineId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GenomicsPipelinesDelete_578939(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a pipeline based on ID.
  ## 
  ## Caller must have WRITE permission to the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pipelineId: JString (required)
  ##             : Caller must have WRITE access to the project in which this pipeline
  ## is defined.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `pipelineId` field"
  var valid_578941 = path.getOrDefault("pipelineId")
  valid_578941 = validateParameter(valid_578941, JString, required = true,
                                 default = nil)
  if valid_578941 != nil:
    section.add "pipelineId", valid_578941
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
  var valid_578942 = query.getOrDefault("key")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "key", valid_578942
  var valid_578943 = query.getOrDefault("prettyPrint")
  valid_578943 = validateParameter(valid_578943, JBool, required = false,
                                 default = newJBool(true))
  if valid_578943 != nil:
    section.add "prettyPrint", valid_578943
  var valid_578944 = query.getOrDefault("oauth_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "oauth_token", valid_578944
  var valid_578945 = query.getOrDefault("$.xgafv")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("1"))
  if valid_578945 != nil:
    section.add "$.xgafv", valid_578945
  var valid_578946 = query.getOrDefault("alt")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("json"))
  if valid_578946 != nil:
    section.add "alt", valid_578946
  var valid_578947 = query.getOrDefault("uploadType")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "uploadType", valid_578947
  var valid_578948 = query.getOrDefault("quotaUser")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "quotaUser", valid_578948
  var valid_578949 = query.getOrDefault("callback")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "callback", valid_578949
  var valid_578950 = query.getOrDefault("fields")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "fields", valid_578950
  var valid_578951 = query.getOrDefault("access_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "access_token", valid_578951
  var valid_578952 = query.getOrDefault("upload_protocol")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "upload_protocol", valid_578952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578953: Call_GenomicsPipelinesDelete_578938; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a pipeline based on ID.
  ## 
  ## Caller must have WRITE permission to the project.
  ## 
  let valid = call_578953.validator(path, query, header, formData, body)
  let scheme = call_578953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578953.url(scheme.get, call_578953.host, call_578953.base,
                         call_578953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578953, url, valid)

proc call*(call_578954: Call_GenomicsPipelinesDelete_578938; pipelineId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## genomicsPipelinesDelete
  ## Deletes a pipeline based on ID.
  ## 
  ## Caller must have WRITE permission to the project.
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
  ##   callback: string
  ##           : JSONP
  ##   pipelineId: string (required)
  ##             : Caller must have WRITE access to the project in which this pipeline
  ## is defined.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578955 = newJObject()
  var query_578956 = newJObject()
  add(query_578956, "key", newJString(key))
  add(query_578956, "prettyPrint", newJBool(prettyPrint))
  add(query_578956, "oauth_token", newJString(oauthToken))
  add(query_578956, "$.xgafv", newJString(Xgafv))
  add(query_578956, "alt", newJString(alt))
  add(query_578956, "uploadType", newJString(uploadType))
  add(query_578956, "quotaUser", newJString(quotaUser))
  add(query_578956, "callback", newJString(callback))
  add(path_578955, "pipelineId", newJString(pipelineId))
  add(query_578956, "fields", newJString(fields))
  add(query_578956, "access_token", newJString(accessToken))
  add(query_578956, "upload_protocol", newJString(uploadProtocol))
  result = call_578954.call(path_578955, query_578956, nil, nil, nil)

var genomicsPipelinesDelete* = Call_GenomicsPipelinesDelete_578938(
    name: "genomicsPipelinesDelete", meth: HttpMethod.HttpDelete,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines/{pipelineId}",
    validator: validate_GenomicsPipelinesDelete_578939, base: "/",
    url: url_GenomicsPipelinesDelete_578940, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesGetControllerConfig_578957 = ref object of OpenApiRestCall_578339
proc url_GenomicsPipelinesGetControllerConfig_578959(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesGetControllerConfig_578958(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets controller configuration information. Should only be called
  ## by VMs created by the Pipelines Service and not by end users.
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
  ##   operationId: JString
  ##              : The operation to retrieve controller configuration for.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   validationToken: JString
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578960 = query.getOrDefault("key")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "key", valid_578960
  var valid_578961 = query.getOrDefault("prettyPrint")
  valid_578961 = validateParameter(valid_578961, JBool, required = false,
                                 default = newJBool(true))
  if valid_578961 != nil:
    section.add "prettyPrint", valid_578961
  var valid_578962 = query.getOrDefault("oauth_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "oauth_token", valid_578962
  var valid_578963 = query.getOrDefault("$.xgafv")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("1"))
  if valid_578963 != nil:
    section.add "$.xgafv", valid_578963
  var valid_578964 = query.getOrDefault("alt")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("json"))
  if valid_578964 != nil:
    section.add "alt", valid_578964
  var valid_578965 = query.getOrDefault("uploadType")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "uploadType", valid_578965
  var valid_578966 = query.getOrDefault("operationId")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "operationId", valid_578966
  var valid_578967 = query.getOrDefault("quotaUser")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "quotaUser", valid_578967
  var valid_578968 = query.getOrDefault("validationToken")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "validationToken", valid_578968
  var valid_578969 = query.getOrDefault("callback")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "callback", valid_578969
  var valid_578970 = query.getOrDefault("fields")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "fields", valid_578970
  var valid_578971 = query.getOrDefault("access_token")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "access_token", valid_578971
  var valid_578972 = query.getOrDefault("upload_protocol")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "upload_protocol", valid_578972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578973: Call_GenomicsPipelinesGetControllerConfig_578957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets controller configuration information. Should only be called
  ## by VMs created by the Pipelines Service and not by end users.
  ## 
  let valid = call_578973.validator(path, query, header, formData, body)
  let scheme = call_578973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578973.url(scheme.get, call_578973.host, call_578973.base,
                         call_578973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578973, url, valid)

proc call*(call_578974: Call_GenomicsPipelinesGetControllerConfig_578957;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          operationId: string = ""; quotaUser: string = "";
          validationToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## genomicsPipelinesGetControllerConfig
  ## Gets controller configuration information. Should only be called
  ## by VMs created by the Pipelines Service and not by end users.
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
  ##   operationId: string
  ##              : The operation to retrieve controller configuration for.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   validationToken: string
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578975 = newJObject()
  add(query_578975, "key", newJString(key))
  add(query_578975, "prettyPrint", newJBool(prettyPrint))
  add(query_578975, "oauth_token", newJString(oauthToken))
  add(query_578975, "$.xgafv", newJString(Xgafv))
  add(query_578975, "alt", newJString(alt))
  add(query_578975, "uploadType", newJString(uploadType))
  add(query_578975, "operationId", newJString(operationId))
  add(query_578975, "quotaUser", newJString(quotaUser))
  add(query_578975, "validationToken", newJString(validationToken))
  add(query_578975, "callback", newJString(callback))
  add(query_578975, "fields", newJString(fields))
  add(query_578975, "access_token", newJString(accessToken))
  add(query_578975, "upload_protocol", newJString(uploadProtocol))
  result = call_578974.call(nil, query_578975, nil, nil, nil)

var genomicsPipelinesGetControllerConfig* = Call_GenomicsPipelinesGetControllerConfig_578957(
    name: "genomicsPipelinesGetControllerConfig", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com",
    route: "/v1alpha2/pipelines:getControllerConfig",
    validator: validate_GenomicsPipelinesGetControllerConfig_578958, base: "/",
    url: url_GenomicsPipelinesGetControllerConfig_578959, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesRun_578976 = ref object of OpenApiRestCall_578339
proc url_GenomicsPipelinesRun_578978(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesRun_578977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs a pipeline. If `pipelineId` is specified in the request, then
  ## run a saved pipeline. If `ephemeralPipeline` is specified, then run
  ## that pipeline once without saving a copy.
  ## 
  ## The caller must have READ permission to the project where the pipeline
  ## is stored and WRITE permission to the project where the pipeline will be
  ## run, as VMs will be created and storage will be used.
  ## 
  ## If a pipeline operation is still running after 6 days, it will be canceled.
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
  var valid_578979 = query.getOrDefault("key")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "key", valid_578979
  var valid_578980 = query.getOrDefault("prettyPrint")
  valid_578980 = validateParameter(valid_578980, JBool, required = false,
                                 default = newJBool(true))
  if valid_578980 != nil:
    section.add "prettyPrint", valid_578980
  var valid_578981 = query.getOrDefault("oauth_token")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "oauth_token", valid_578981
  var valid_578982 = query.getOrDefault("$.xgafv")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = newJString("1"))
  if valid_578982 != nil:
    section.add "$.xgafv", valid_578982
  var valid_578983 = query.getOrDefault("alt")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = newJString("json"))
  if valid_578983 != nil:
    section.add "alt", valid_578983
  var valid_578984 = query.getOrDefault("uploadType")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "uploadType", valid_578984
  var valid_578985 = query.getOrDefault("quotaUser")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "quotaUser", valid_578985
  var valid_578986 = query.getOrDefault("callback")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "callback", valid_578986
  var valid_578987 = query.getOrDefault("fields")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "fields", valid_578987
  var valid_578988 = query.getOrDefault("access_token")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "access_token", valid_578988
  var valid_578989 = query.getOrDefault("upload_protocol")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "upload_protocol", valid_578989
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

proc call*(call_578991: Call_GenomicsPipelinesRun_578976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a pipeline. If `pipelineId` is specified in the request, then
  ## run a saved pipeline. If `ephemeralPipeline` is specified, then run
  ## that pipeline once without saving a copy.
  ## 
  ## The caller must have READ permission to the project where the pipeline
  ## is stored and WRITE permission to the project where the pipeline will be
  ## run, as VMs will be created and storage will be used.
  ## 
  ## If a pipeline operation is still running after 6 days, it will be canceled.
  ## 
  let valid = call_578991.validator(path, query, header, formData, body)
  let scheme = call_578991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578991.url(scheme.get, call_578991.host, call_578991.base,
                         call_578991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578991, url, valid)

proc call*(call_578992: Call_GenomicsPipelinesRun_578976; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## genomicsPipelinesRun
  ## Runs a pipeline. If `pipelineId` is specified in the request, then
  ## run a saved pipeline. If `ephemeralPipeline` is specified, then run
  ## that pipeline once without saving a copy.
  ## 
  ## The caller must have READ permission to the project where the pipeline
  ## is stored and WRITE permission to the project where the pipeline will be
  ## run, as VMs will be created and storage will be used.
  ## 
  ## If a pipeline operation is still running after 6 days, it will be canceled.
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
  var query_578993 = newJObject()
  var body_578994 = newJObject()
  add(query_578993, "key", newJString(key))
  add(query_578993, "prettyPrint", newJBool(prettyPrint))
  add(query_578993, "oauth_token", newJString(oauthToken))
  add(query_578993, "$.xgafv", newJString(Xgafv))
  add(query_578993, "alt", newJString(alt))
  add(query_578993, "uploadType", newJString(uploadType))
  add(query_578993, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578994 = body
  add(query_578993, "callback", newJString(callback))
  add(query_578993, "fields", newJString(fields))
  add(query_578993, "access_token", newJString(accessToken))
  add(query_578993, "upload_protocol", newJString(uploadProtocol))
  result = call_578992.call(nil, query_578993, nil, nil, body_578994)

var genomicsPipelinesRun* = Call_GenomicsPipelinesRun_578976(
    name: "genomicsPipelinesRun", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines:run",
    validator: validate_GenomicsPipelinesRun_578977, base: "/",
    url: url_GenomicsPipelinesRun_578978, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesSetOperationStatus_578995 = ref object of OpenApiRestCall_578339
proc url_GenomicsPipelinesSetOperationStatus_578997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesSetOperationStatus_578996(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets status of a given operation. Any new timestamps (as determined by
  ## description) are appended to TimestampEvents. Should only be called by VMs
  ## created by the Pipelines Service and not by end users.
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
  var valid_578998 = query.getOrDefault("key")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "key", valid_578998
  var valid_578999 = query.getOrDefault("prettyPrint")
  valid_578999 = validateParameter(valid_578999, JBool, required = false,
                                 default = newJBool(true))
  if valid_578999 != nil:
    section.add "prettyPrint", valid_578999
  var valid_579000 = query.getOrDefault("oauth_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "oauth_token", valid_579000
  var valid_579001 = query.getOrDefault("$.xgafv")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("1"))
  if valid_579001 != nil:
    section.add "$.xgafv", valid_579001
  var valid_579002 = query.getOrDefault("alt")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = newJString("json"))
  if valid_579002 != nil:
    section.add "alt", valid_579002
  var valid_579003 = query.getOrDefault("uploadType")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "uploadType", valid_579003
  var valid_579004 = query.getOrDefault("quotaUser")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "quotaUser", valid_579004
  var valid_579005 = query.getOrDefault("callback")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "callback", valid_579005
  var valid_579006 = query.getOrDefault("fields")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "fields", valid_579006
  var valid_579007 = query.getOrDefault("access_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "access_token", valid_579007
  var valid_579008 = query.getOrDefault("upload_protocol")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "upload_protocol", valid_579008
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

proc call*(call_579010: Call_GenomicsPipelinesSetOperationStatus_578995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets status of a given operation. Any new timestamps (as determined by
  ## description) are appended to TimestampEvents. Should only be called by VMs
  ## created by the Pipelines Service and not by end users.
  ## 
  let valid = call_579010.validator(path, query, header, formData, body)
  let scheme = call_579010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579010.url(scheme.get, call_579010.host, call_579010.base,
                         call_579010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579010, url, valid)

proc call*(call_579011: Call_GenomicsPipelinesSetOperationStatus_578995;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## genomicsPipelinesSetOperationStatus
  ## Sets status of a given operation. Any new timestamps (as determined by
  ## description) are appended to TimestampEvents. Should only be called by VMs
  ## created by the Pipelines Service and not by end users.
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
  var query_579012 = newJObject()
  var body_579013 = newJObject()
  add(query_579012, "key", newJString(key))
  add(query_579012, "prettyPrint", newJBool(prettyPrint))
  add(query_579012, "oauth_token", newJString(oauthToken))
  add(query_579012, "$.xgafv", newJString(Xgafv))
  add(query_579012, "alt", newJString(alt))
  add(query_579012, "uploadType", newJString(uploadType))
  add(query_579012, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579013 = body
  add(query_579012, "callback", newJString(callback))
  add(query_579012, "fields", newJString(fields))
  add(query_579012, "access_token", newJString(accessToken))
  add(query_579012, "upload_protocol", newJString(uploadProtocol))
  result = call_579011.call(nil, query_579012, nil, nil, body_579013)

var genomicsPipelinesSetOperationStatus* = Call_GenomicsPipelinesSetOperationStatus_578995(
    name: "genomicsPipelinesSetOperationStatus", meth: HttpMethod.HttpPut,
    host: "genomics.googleapis.com",
    route: "/v1alpha2/pipelines:setOperationStatus",
    validator: validate_GenomicsPipelinesSetOperationStatus_578996, base: "/",
    url: url_GenomicsPipelinesSetOperationStatus_578997, schemes: {Scheme.Https})
type
  Call_GenomicsOperationsGet_579014 = ref object of OpenApiRestCall_578339
proc url_GenomicsOperationsGet_579016(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GenomicsOperationsGet_579015(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.
  ## Clients can use this method to poll the operation result at intervals as
  ## recommended by the API service.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.get`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579017 = path.getOrDefault("name")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "name", valid_579017
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
  var valid_579018 = query.getOrDefault("key")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "key", valid_579018
  var valid_579019 = query.getOrDefault("prettyPrint")
  valid_579019 = validateParameter(valid_579019, JBool, required = false,
                                 default = newJBool(true))
  if valid_579019 != nil:
    section.add "prettyPrint", valid_579019
  var valid_579020 = query.getOrDefault("oauth_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "oauth_token", valid_579020
  var valid_579021 = query.getOrDefault("$.xgafv")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("1"))
  if valid_579021 != nil:
    section.add "$.xgafv", valid_579021
  var valid_579022 = query.getOrDefault("alt")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("json"))
  if valid_579022 != nil:
    section.add "alt", valid_579022
  var valid_579023 = query.getOrDefault("uploadType")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "uploadType", valid_579023
  var valid_579024 = query.getOrDefault("quotaUser")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "quotaUser", valid_579024
  var valid_579025 = query.getOrDefault("callback")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "callback", valid_579025
  var valid_579026 = query.getOrDefault("fields")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "fields", valid_579026
  var valid_579027 = query.getOrDefault("access_token")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "access_token", valid_579027
  var valid_579028 = query.getOrDefault("upload_protocol")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "upload_protocol", valid_579028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579029: Call_GenomicsOperationsGet_579014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.
  ## Clients can use this method to poll the operation result at intervals as
  ## recommended by the API service.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.get`
  ## 
  let valid = call_579029.validator(path, query, header, formData, body)
  let scheme = call_579029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579029.url(scheme.get, call_579029.host, call_579029.base,
                         call_579029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579029, url, valid)

proc call*(call_579030: Call_GenomicsOperationsGet_579014; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## genomicsOperationsGet
  ## Gets the latest state of a long-running operation.
  ## Clients can use this method to poll the operation result at intervals as
  ## recommended by the API service.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.get`
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
  ##   name: string (required)
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579031 = newJObject()
  var query_579032 = newJObject()
  add(query_579032, "key", newJString(key))
  add(query_579032, "prettyPrint", newJBool(prettyPrint))
  add(query_579032, "oauth_token", newJString(oauthToken))
  add(query_579032, "$.xgafv", newJString(Xgafv))
  add(query_579032, "alt", newJString(alt))
  add(query_579032, "uploadType", newJString(uploadType))
  add(query_579032, "quotaUser", newJString(quotaUser))
  add(path_579031, "name", newJString(name))
  add(query_579032, "callback", newJString(callback))
  add(query_579032, "fields", newJString(fields))
  add(query_579032, "access_token", newJString(accessToken))
  add(query_579032, "upload_protocol", newJString(uploadProtocol))
  result = call_579030.call(path_579031, query_579032, nil, nil, nil)

var genomicsOperationsGet* = Call_GenomicsOperationsGet_579014(
    name: "genomicsOperationsGet", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/{name}",
    validator: validate_GenomicsOperationsGet_579015, base: "/",
    url: url_GenomicsOperationsGet_579016, schemes: {Scheme.Https})
type
  Call_GenomicsOperationsCancel_579033 = ref object of OpenApiRestCall_578339
proc url_GenomicsOperationsCancel_579035(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GenomicsOperationsCancel_579034(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.
  ## The server makes a best effort to cancel the operation, but success is not
  ## guaranteed. Clients may use Operations.GetOperation
  ## or Operations.ListOperations
  ## to check whether the cancellation succeeded or the operation completed
  ## despite cancellation.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.cancel`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579036 = path.getOrDefault("name")
  valid_579036 = validateParameter(valid_579036, JString, required = true,
                                 default = nil)
  if valid_579036 != nil:
    section.add "name", valid_579036
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
  var valid_579037 = query.getOrDefault("key")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "key", valid_579037
  var valid_579038 = query.getOrDefault("prettyPrint")
  valid_579038 = validateParameter(valid_579038, JBool, required = false,
                                 default = newJBool(true))
  if valid_579038 != nil:
    section.add "prettyPrint", valid_579038
  var valid_579039 = query.getOrDefault("oauth_token")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "oauth_token", valid_579039
  var valid_579040 = query.getOrDefault("$.xgafv")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("1"))
  if valid_579040 != nil:
    section.add "$.xgafv", valid_579040
  var valid_579041 = query.getOrDefault("alt")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = newJString("json"))
  if valid_579041 != nil:
    section.add "alt", valid_579041
  var valid_579042 = query.getOrDefault("uploadType")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "uploadType", valid_579042
  var valid_579043 = query.getOrDefault("quotaUser")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "quotaUser", valid_579043
  var valid_579044 = query.getOrDefault("callback")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "callback", valid_579044
  var valid_579045 = query.getOrDefault("fields")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "fields", valid_579045
  var valid_579046 = query.getOrDefault("access_token")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "access_token", valid_579046
  var valid_579047 = query.getOrDefault("upload_protocol")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "upload_protocol", valid_579047
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

proc call*(call_579049: Call_GenomicsOperationsCancel_579033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.
  ## The server makes a best effort to cancel the operation, but success is not
  ## guaranteed. Clients may use Operations.GetOperation
  ## or Operations.ListOperations
  ## to check whether the cancellation succeeded or the operation completed
  ## despite cancellation.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.cancel`
  ## 
  let valid = call_579049.validator(path, query, header, formData, body)
  let scheme = call_579049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579049.url(scheme.get, call_579049.host, call_579049.base,
                         call_579049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579049, url, valid)

proc call*(call_579050: Call_GenomicsOperationsCancel_579033; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## genomicsOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.
  ## The server makes a best effort to cancel the operation, but success is not
  ## guaranteed. Clients may use Operations.GetOperation
  ## or Operations.ListOperations
  ## to check whether the cancellation succeeded or the operation completed
  ## despite cancellation.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.cancel`
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
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579051 = newJObject()
  var query_579052 = newJObject()
  var body_579053 = newJObject()
  add(query_579052, "key", newJString(key))
  add(query_579052, "prettyPrint", newJBool(prettyPrint))
  add(query_579052, "oauth_token", newJString(oauthToken))
  add(query_579052, "$.xgafv", newJString(Xgafv))
  add(query_579052, "alt", newJString(alt))
  add(query_579052, "uploadType", newJString(uploadType))
  add(query_579052, "quotaUser", newJString(quotaUser))
  add(path_579051, "name", newJString(name))
  if body != nil:
    body_579053 = body
  add(query_579052, "callback", newJString(callback))
  add(query_579052, "fields", newJString(fields))
  add(query_579052, "access_token", newJString(accessToken))
  add(query_579052, "upload_protocol", newJString(uploadProtocol))
  result = call_579050.call(path_579051, query_579052, nil, nil, body_579053)

var genomicsOperationsCancel* = Call_GenomicsOperationsCancel_579033(
    name: "genomicsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/{name}:cancel",
    validator: validate_GenomicsOperationsCancel_579034, base: "/",
    url: url_GenomicsOperationsCancel_579035, schemes: {Scheme.Https})
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
