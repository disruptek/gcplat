
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Run
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Deploy and manage user provided container images that scale automatically based on HTTP traffic.
## 
## https://cloud.google.com/run/
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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
  gcpServiceName = "run"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RunNamespacesDomainmappingsReplaceDomainMapping_593978 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesDomainmappingsReplaceDomainMapping_593980(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsReplaceDomainMapping_593979(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593981 = path.getOrDefault("name")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "name", valid_593981
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
  var valid_593982 = query.getOrDefault("upload_protocol")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "upload_protocol", valid_593982
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("callback")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "callback", valid_593987
  var valid_593988 = query.getOrDefault("access_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "access_token", valid_593988
  var valid_593989 = query.getOrDefault("uploadType")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "uploadType", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("$.xgafv")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("1"))
  if valid_593991 != nil:
    section.add "$.xgafv", valid_593991
  var valid_593992 = query.getOrDefault("prettyPrint")
  valid_593992 = validateParameter(valid_593992, JBool, required = false,
                                 default = newJBool(true))
  if valid_593992 != nil:
    section.add "prettyPrint", valid_593992
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

proc call*(call_593994: Call_RunNamespacesDomainmappingsReplaceDomainMapping_593978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_RunNamespacesDomainmappingsReplaceDomainMapping_593978;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesDomainmappingsReplaceDomainMapping
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  var body_593998 = newJObject()
  add(query_593997, "upload_protocol", newJString(uploadProtocol))
  add(query_593997, "fields", newJString(fields))
  add(query_593997, "quotaUser", newJString(quotaUser))
  add(path_593996, "name", newJString(name))
  add(query_593997, "alt", newJString(alt))
  add(query_593997, "oauth_token", newJString(oauthToken))
  add(query_593997, "callback", newJString(callback))
  add(query_593997, "access_token", newJString(accessToken))
  add(query_593997, "uploadType", newJString(uploadType))
  add(query_593997, "key", newJString(key))
  add(query_593997, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593998 = body
  add(query_593997, "prettyPrint", newJBool(prettyPrint))
  result = call_593995.call(path_593996, query_593997, nil, nil, body_593998)

var runNamespacesDomainmappingsReplaceDomainMapping* = Call_RunNamespacesDomainmappingsReplaceDomainMapping_593978(
    name: "runNamespacesDomainmappingsReplaceDomainMapping",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsReplaceDomainMapping_593979,
    base: "/", url: url_RunNamespacesDomainmappingsReplaceDomainMapping_593980,
    schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsGet_593690 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesDomainmappingsGet_593692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsGet_593691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593818 = path.getOrDefault("name")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "name", valid_593818
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
  var valid_593819 = query.getOrDefault("upload_protocol")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "upload_protocol", valid_593819
  var valid_593820 = query.getOrDefault("fields")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "fields", valid_593820
  var valid_593821 = query.getOrDefault("quotaUser")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "quotaUser", valid_593821
  var valid_593835 = query.getOrDefault("alt")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("json"))
  if valid_593835 != nil:
    section.add "alt", valid_593835
  var valid_593836 = query.getOrDefault("oauth_token")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "oauth_token", valid_593836
  var valid_593837 = query.getOrDefault("callback")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "callback", valid_593837
  var valid_593838 = query.getOrDefault("access_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "access_token", valid_593838
  var valid_593839 = query.getOrDefault("uploadType")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "uploadType", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("$.xgafv")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = newJString("1"))
  if valid_593841 != nil:
    section.add "$.xgafv", valid_593841
  var valid_593842 = query.getOrDefault("prettyPrint")
  valid_593842 = validateParameter(valid_593842, JBool, required = false,
                                 default = newJBool(true))
  if valid_593842 != nil:
    section.add "prettyPrint", valid_593842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593865: Call_RunNamespacesDomainmappingsGet_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a domain mapping.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_RunNamespacesDomainmappingsGet_593690; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runNamespacesDomainmappingsGet
  ## Get information about a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  add(query_593939, "upload_protocol", newJString(uploadProtocol))
  add(query_593939, "fields", newJString(fields))
  add(query_593939, "quotaUser", newJString(quotaUser))
  add(path_593937, "name", newJString(name))
  add(query_593939, "alt", newJString(alt))
  add(query_593939, "oauth_token", newJString(oauthToken))
  add(query_593939, "callback", newJString(callback))
  add(query_593939, "access_token", newJString(accessToken))
  add(query_593939, "uploadType", newJString(uploadType))
  add(query_593939, "key", newJString(key))
  add(query_593939, "$.xgafv", newJString(Xgafv))
  add(query_593939, "prettyPrint", newJBool(prettyPrint))
  result = call_593936.call(path_593937, query_593939, nil, nil, nil)

var runNamespacesDomainmappingsGet* = Call_RunNamespacesDomainmappingsGet_593690(
    name: "runNamespacesDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsGet_593691, base: "/",
    url: url_RunNamespacesDomainmappingsGet_593692, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsDelete_593999 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesDomainmappingsDelete_594001(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsDelete_594000(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594002 = path.getOrDefault("name")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "name", valid_594002
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
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  section = newJObject()
  var valid_594003 = query.getOrDefault("upload_protocol")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "upload_protocol", valid_594003
  var valid_594004 = query.getOrDefault("fields")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "fields", valid_594004
  var valid_594005 = query.getOrDefault("quotaUser")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "quotaUser", valid_594005
  var valid_594006 = query.getOrDefault("alt")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = newJString("json"))
  if valid_594006 != nil:
    section.add "alt", valid_594006
  var valid_594007 = query.getOrDefault("oauth_token")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "oauth_token", valid_594007
  var valid_594008 = query.getOrDefault("callback")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "callback", valid_594008
  var valid_594009 = query.getOrDefault("access_token")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "access_token", valid_594009
  var valid_594010 = query.getOrDefault("uploadType")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "uploadType", valid_594010
  var valid_594011 = query.getOrDefault("kind")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "kind", valid_594011
  var valid_594012 = query.getOrDefault("key")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "key", valid_594012
  var valid_594013 = query.getOrDefault("$.xgafv")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = newJString("1"))
  if valid_594013 != nil:
    section.add "$.xgafv", valid_594013
  var valid_594014 = query.getOrDefault("prettyPrint")
  valid_594014 = validateParameter(valid_594014, JBool, required = false,
                                 default = newJBool(true))
  if valid_594014 != nil:
    section.add "prettyPrint", valid_594014
  var valid_594015 = query.getOrDefault("propagationPolicy")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "propagationPolicy", valid_594015
  var valid_594016 = query.getOrDefault("apiVersion")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "apiVersion", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_RunNamespacesDomainmappingsDelete_593999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a domain mapping.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_RunNamespacesDomainmappingsDelete_593999;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runNamespacesDomainmappingsDelete
  ## Delete a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(query_594020, "upload_protocol", newJString(uploadProtocol))
  add(query_594020, "fields", newJString(fields))
  add(query_594020, "quotaUser", newJString(quotaUser))
  add(path_594019, "name", newJString(name))
  add(query_594020, "alt", newJString(alt))
  add(query_594020, "oauth_token", newJString(oauthToken))
  add(query_594020, "callback", newJString(callback))
  add(query_594020, "access_token", newJString(accessToken))
  add(query_594020, "uploadType", newJString(uploadType))
  add(query_594020, "kind", newJString(kind))
  add(query_594020, "key", newJString(key))
  add(query_594020, "$.xgafv", newJString(Xgafv))
  add(query_594020, "prettyPrint", newJBool(prettyPrint))
  add(query_594020, "propagationPolicy", newJString(propagationPolicy))
  add(query_594020, "apiVersion", newJString(apiVersion))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var runNamespacesDomainmappingsDelete* = Call_RunNamespacesDomainmappingsDelete_593999(
    name: "runNamespacesDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsDelete_594000, base: "/",
    url: url_RunNamespacesDomainmappingsDelete_594001, schemes: {Scheme.Https})
type
  Call_RunNamespacesAuthorizeddomainsList_594021 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesAuthorizeddomainsList_594023(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/authorizeddomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesAuthorizeddomainsList_594022(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List authorized domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594024 = path.getOrDefault("parent")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "parent", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
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
  ##   pageSize: JInt
  ##           : Maximum results to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594025 = query.getOrDefault("upload_protocol")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "upload_protocol", valid_594025
  var valid_594026 = query.getOrDefault("fields")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "fields", valid_594026
  var valid_594027 = query.getOrDefault("pageToken")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "pageToken", valid_594027
  var valid_594028 = query.getOrDefault("quotaUser")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "quotaUser", valid_594028
  var valid_594029 = query.getOrDefault("alt")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = newJString("json"))
  if valid_594029 != nil:
    section.add "alt", valid_594029
  var valid_594030 = query.getOrDefault("oauth_token")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "oauth_token", valid_594030
  var valid_594031 = query.getOrDefault("callback")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "callback", valid_594031
  var valid_594032 = query.getOrDefault("access_token")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "access_token", valid_594032
  var valid_594033 = query.getOrDefault("uploadType")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "uploadType", valid_594033
  var valid_594034 = query.getOrDefault("key")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "key", valid_594034
  var valid_594035 = query.getOrDefault("$.xgafv")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = newJString("1"))
  if valid_594035 != nil:
    section.add "$.xgafv", valid_594035
  var valid_594036 = query.getOrDefault("pageSize")
  valid_594036 = validateParameter(valid_594036, JInt, required = false, default = nil)
  if valid_594036 != nil:
    section.add "pageSize", valid_594036
  var valid_594037 = query.getOrDefault("prettyPrint")
  valid_594037 = validateParameter(valid_594037, JBool, required = false,
                                 default = newJBool(true))
  if valid_594037 != nil:
    section.add "prettyPrint", valid_594037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_RunNamespacesAuthorizeddomainsList_594021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List authorized domains.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_RunNamespacesAuthorizeddomainsList_594021;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesAuthorizeddomainsList
  ## List authorized domains.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
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
  ##   parent: string (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(query_594041, "upload_protocol", newJString(uploadProtocol))
  add(query_594041, "fields", newJString(fields))
  add(query_594041, "pageToken", newJString(pageToken))
  add(query_594041, "quotaUser", newJString(quotaUser))
  add(query_594041, "alt", newJString(alt))
  add(query_594041, "oauth_token", newJString(oauthToken))
  add(query_594041, "callback", newJString(callback))
  add(query_594041, "access_token", newJString(accessToken))
  add(query_594041, "uploadType", newJString(uploadType))
  add(path_594040, "parent", newJString(parent))
  add(query_594041, "key", newJString(key))
  add(query_594041, "$.xgafv", newJString(Xgafv))
  add(query_594041, "pageSize", newJInt(pageSize))
  add(query_594041, "prettyPrint", newJBool(prettyPrint))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var runNamespacesAuthorizeddomainsList* = Call_RunNamespacesAuthorizeddomainsList_594021(
    name: "runNamespacesAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/authorizeddomains",
    validator: validate_RunNamespacesAuthorizeddomainsList_594022, base: "/",
    url: url_RunNamespacesAuthorizeddomainsList_594023, schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsCreate_594068 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesAutodomainmappingsCreate_594070(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesAutodomainmappingsCreate_594069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new auto domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594071 = path.getOrDefault("parent")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "parent", valid_594071
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
  var valid_594072 = query.getOrDefault("upload_protocol")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "upload_protocol", valid_594072
  var valid_594073 = query.getOrDefault("fields")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "fields", valid_594073
  var valid_594074 = query.getOrDefault("quotaUser")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "quotaUser", valid_594074
  var valid_594075 = query.getOrDefault("alt")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = newJString("json"))
  if valid_594075 != nil:
    section.add "alt", valid_594075
  var valid_594076 = query.getOrDefault("oauth_token")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "oauth_token", valid_594076
  var valid_594077 = query.getOrDefault("callback")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "callback", valid_594077
  var valid_594078 = query.getOrDefault("access_token")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "access_token", valid_594078
  var valid_594079 = query.getOrDefault("uploadType")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "uploadType", valid_594079
  var valid_594080 = query.getOrDefault("key")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "key", valid_594080
  var valid_594081 = query.getOrDefault("$.xgafv")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = newJString("1"))
  if valid_594081 != nil:
    section.add "$.xgafv", valid_594081
  var valid_594082 = query.getOrDefault("prettyPrint")
  valid_594082 = validateParameter(valid_594082, JBool, required = false,
                                 default = newJBool(true))
  if valid_594082 != nil:
    section.add "prettyPrint", valid_594082
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

proc call*(call_594084: Call_RunNamespacesAutodomainmappingsCreate_594068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new auto domain mapping.
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_RunNamespacesAutodomainmappingsCreate_594068;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesAutodomainmappingsCreate
  ## Creates a new auto domain mapping.
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
  ##   parent: string (required)
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  var body_594088 = newJObject()
  add(query_594087, "upload_protocol", newJString(uploadProtocol))
  add(query_594087, "fields", newJString(fields))
  add(query_594087, "quotaUser", newJString(quotaUser))
  add(query_594087, "alt", newJString(alt))
  add(query_594087, "oauth_token", newJString(oauthToken))
  add(query_594087, "callback", newJString(callback))
  add(query_594087, "access_token", newJString(accessToken))
  add(query_594087, "uploadType", newJString(uploadType))
  add(path_594086, "parent", newJString(parent))
  add(query_594087, "key", newJString(key))
  add(query_594087, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594088 = body
  add(query_594087, "prettyPrint", newJBool(prettyPrint))
  result = call_594085.call(path_594086, query_594087, nil, nil, body_594088)

var runNamespacesAutodomainmappingsCreate* = Call_RunNamespacesAutodomainmappingsCreate_594068(
    name: "runNamespacesAutodomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/autodomainmappings",
    validator: validate_RunNamespacesAutodomainmappingsCreate_594069, base: "/",
    url: url_RunNamespacesAutodomainmappingsCreate_594070, schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsList_594042 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesAutodomainmappingsList_594044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesAutodomainmappingsList_594043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List auto domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594045 = path.getOrDefault("parent")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "parent", valid_594045
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594046 = query.getOrDefault("upload_protocol")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "upload_protocol", valid_594046
  var valid_594047 = query.getOrDefault("fields")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "fields", valid_594047
  var valid_594048 = query.getOrDefault("quotaUser")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "quotaUser", valid_594048
  var valid_594049 = query.getOrDefault("includeUninitialized")
  valid_594049 = validateParameter(valid_594049, JBool, required = false, default = nil)
  if valid_594049 != nil:
    section.add "includeUninitialized", valid_594049
  var valid_594050 = query.getOrDefault("alt")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = newJString("json"))
  if valid_594050 != nil:
    section.add "alt", valid_594050
  var valid_594051 = query.getOrDefault("continue")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "continue", valid_594051
  var valid_594052 = query.getOrDefault("oauth_token")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "oauth_token", valid_594052
  var valid_594053 = query.getOrDefault("callback")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "callback", valid_594053
  var valid_594054 = query.getOrDefault("access_token")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "access_token", valid_594054
  var valid_594055 = query.getOrDefault("uploadType")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "uploadType", valid_594055
  var valid_594056 = query.getOrDefault("resourceVersion")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "resourceVersion", valid_594056
  var valid_594057 = query.getOrDefault("watch")
  valid_594057 = validateParameter(valid_594057, JBool, required = false, default = nil)
  if valid_594057 != nil:
    section.add "watch", valid_594057
  var valid_594058 = query.getOrDefault("key")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "key", valid_594058
  var valid_594059 = query.getOrDefault("$.xgafv")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = newJString("1"))
  if valid_594059 != nil:
    section.add "$.xgafv", valid_594059
  var valid_594060 = query.getOrDefault("labelSelector")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "labelSelector", valid_594060
  var valid_594061 = query.getOrDefault("prettyPrint")
  valid_594061 = validateParameter(valid_594061, JBool, required = false,
                                 default = newJBool(true))
  if valid_594061 != nil:
    section.add "prettyPrint", valid_594061
  var valid_594062 = query.getOrDefault("fieldSelector")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "fieldSelector", valid_594062
  var valid_594063 = query.getOrDefault("limit")
  valid_594063 = validateParameter(valid_594063, JInt, required = false, default = nil)
  if valid_594063 != nil:
    section.add "limit", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_RunNamespacesAutodomainmappingsList_594042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List auto domain mappings.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_RunNamespacesAutodomainmappingsList_594042;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesAutodomainmappingsList
  ## List auto domain mappings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(query_594067, "upload_protocol", newJString(uploadProtocol))
  add(query_594067, "fields", newJString(fields))
  add(query_594067, "quotaUser", newJString(quotaUser))
  add(query_594067, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594067, "alt", newJString(alt))
  add(query_594067, "continue", newJString(`continue`))
  add(query_594067, "oauth_token", newJString(oauthToken))
  add(query_594067, "callback", newJString(callback))
  add(query_594067, "access_token", newJString(accessToken))
  add(query_594067, "uploadType", newJString(uploadType))
  add(path_594066, "parent", newJString(parent))
  add(query_594067, "resourceVersion", newJString(resourceVersion))
  add(query_594067, "watch", newJBool(watch))
  add(query_594067, "key", newJString(key))
  add(query_594067, "$.xgafv", newJString(Xgafv))
  add(query_594067, "labelSelector", newJString(labelSelector))
  add(query_594067, "prettyPrint", newJBool(prettyPrint))
  add(query_594067, "fieldSelector", newJString(fieldSelector))
  add(query_594067, "limit", newJInt(limit))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var runNamespacesAutodomainmappingsList* = Call_RunNamespacesAutodomainmappingsList_594042(
    name: "runNamespacesAutodomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/autodomainmappings",
    validator: validate_RunNamespacesAutodomainmappingsList_594043, base: "/",
    url: url_RunNamespacesAutodomainmappingsList_594044, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsCreate_594115 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesDomainmappingsCreate_594117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsCreate_594116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594118 = path.getOrDefault("parent")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "parent", valid_594118
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
  var valid_594119 = query.getOrDefault("upload_protocol")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "upload_protocol", valid_594119
  var valid_594120 = query.getOrDefault("fields")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "fields", valid_594120
  var valid_594121 = query.getOrDefault("quotaUser")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "quotaUser", valid_594121
  var valid_594122 = query.getOrDefault("alt")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = newJString("json"))
  if valid_594122 != nil:
    section.add "alt", valid_594122
  var valid_594123 = query.getOrDefault("oauth_token")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "oauth_token", valid_594123
  var valid_594124 = query.getOrDefault("callback")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "callback", valid_594124
  var valid_594125 = query.getOrDefault("access_token")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "access_token", valid_594125
  var valid_594126 = query.getOrDefault("uploadType")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "uploadType", valid_594126
  var valid_594127 = query.getOrDefault("key")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "key", valid_594127
  var valid_594128 = query.getOrDefault("$.xgafv")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = newJString("1"))
  if valid_594128 != nil:
    section.add "$.xgafv", valid_594128
  var valid_594129 = query.getOrDefault("prettyPrint")
  valid_594129 = validateParameter(valid_594129, JBool, required = false,
                                 default = newJBool(true))
  if valid_594129 != nil:
    section.add "prettyPrint", valid_594129
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

proc call*(call_594131: Call_RunNamespacesDomainmappingsCreate_594115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new domain mapping.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_RunNamespacesDomainmappingsCreate_594115;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesDomainmappingsCreate
  ## Create a new domain mapping.
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
  ##   parent: string (required)
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  var body_594135 = newJObject()
  add(query_594134, "upload_protocol", newJString(uploadProtocol))
  add(query_594134, "fields", newJString(fields))
  add(query_594134, "quotaUser", newJString(quotaUser))
  add(query_594134, "alt", newJString(alt))
  add(query_594134, "oauth_token", newJString(oauthToken))
  add(query_594134, "callback", newJString(callback))
  add(query_594134, "access_token", newJString(accessToken))
  add(query_594134, "uploadType", newJString(uploadType))
  add(path_594133, "parent", newJString(parent))
  add(query_594134, "key", newJString(key))
  add(query_594134, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594135 = body
  add(query_594134, "prettyPrint", newJBool(prettyPrint))
  result = call_594132.call(path_594133, query_594134, nil, nil, body_594135)

var runNamespacesDomainmappingsCreate* = Call_RunNamespacesDomainmappingsCreate_594115(
    name: "runNamespacesDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsCreate_594116, base: "/",
    url: url_RunNamespacesDomainmappingsCreate_594117, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsList_594089 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesDomainmappingsList_594091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsList_594090(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594092 = path.getOrDefault("parent")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "parent", valid_594092
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594093 = query.getOrDefault("upload_protocol")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "upload_protocol", valid_594093
  var valid_594094 = query.getOrDefault("fields")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "fields", valid_594094
  var valid_594095 = query.getOrDefault("quotaUser")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "quotaUser", valid_594095
  var valid_594096 = query.getOrDefault("includeUninitialized")
  valid_594096 = validateParameter(valid_594096, JBool, required = false, default = nil)
  if valid_594096 != nil:
    section.add "includeUninitialized", valid_594096
  var valid_594097 = query.getOrDefault("alt")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = newJString("json"))
  if valid_594097 != nil:
    section.add "alt", valid_594097
  var valid_594098 = query.getOrDefault("continue")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "continue", valid_594098
  var valid_594099 = query.getOrDefault("oauth_token")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "oauth_token", valid_594099
  var valid_594100 = query.getOrDefault("callback")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "callback", valid_594100
  var valid_594101 = query.getOrDefault("access_token")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "access_token", valid_594101
  var valid_594102 = query.getOrDefault("uploadType")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "uploadType", valid_594102
  var valid_594103 = query.getOrDefault("resourceVersion")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "resourceVersion", valid_594103
  var valid_594104 = query.getOrDefault("watch")
  valid_594104 = validateParameter(valid_594104, JBool, required = false, default = nil)
  if valid_594104 != nil:
    section.add "watch", valid_594104
  var valid_594105 = query.getOrDefault("key")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "key", valid_594105
  var valid_594106 = query.getOrDefault("$.xgafv")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = newJString("1"))
  if valid_594106 != nil:
    section.add "$.xgafv", valid_594106
  var valid_594107 = query.getOrDefault("labelSelector")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "labelSelector", valid_594107
  var valid_594108 = query.getOrDefault("prettyPrint")
  valid_594108 = validateParameter(valid_594108, JBool, required = false,
                                 default = newJBool(true))
  if valid_594108 != nil:
    section.add "prettyPrint", valid_594108
  var valid_594109 = query.getOrDefault("fieldSelector")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "fieldSelector", valid_594109
  var valid_594110 = query.getOrDefault("limit")
  valid_594110 = validateParameter(valid_594110, JInt, required = false, default = nil)
  if valid_594110 != nil:
    section.add "limit", valid_594110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594111: Call_RunNamespacesDomainmappingsList_594089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List domain mappings.
  ## 
  let valid = call_594111.validator(path, query, header, formData, body)
  let scheme = call_594111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594111.url(scheme.get, call_594111.host, call_594111.base,
                         call_594111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594111, url, valid)

proc call*(call_594112: Call_RunNamespacesDomainmappingsList_594089;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesDomainmappingsList
  ## List domain mappings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594113 = newJObject()
  var query_594114 = newJObject()
  add(query_594114, "upload_protocol", newJString(uploadProtocol))
  add(query_594114, "fields", newJString(fields))
  add(query_594114, "quotaUser", newJString(quotaUser))
  add(query_594114, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594114, "alt", newJString(alt))
  add(query_594114, "continue", newJString(`continue`))
  add(query_594114, "oauth_token", newJString(oauthToken))
  add(query_594114, "callback", newJString(callback))
  add(query_594114, "access_token", newJString(accessToken))
  add(query_594114, "uploadType", newJString(uploadType))
  add(path_594113, "parent", newJString(parent))
  add(query_594114, "resourceVersion", newJString(resourceVersion))
  add(query_594114, "watch", newJBool(watch))
  add(query_594114, "key", newJString(key))
  add(query_594114, "$.xgafv", newJString(Xgafv))
  add(query_594114, "labelSelector", newJString(labelSelector))
  add(query_594114, "prettyPrint", newJBool(prettyPrint))
  add(query_594114, "fieldSelector", newJString(fieldSelector))
  add(query_594114, "limit", newJInt(limit))
  result = call_594112.call(path_594113, query_594114, nil, nil, nil)

var runNamespacesDomainmappingsList* = Call_RunNamespacesDomainmappingsList_594089(
    name: "runNamespacesDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsList_594090, base: "/",
    url: url_RunNamespacesDomainmappingsList_594091, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsReplaceConfiguration_594155 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesConfigurationsReplaceConfiguration_594157(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsReplaceConfiguration_594156(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Replace a configuration.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594158 = path.getOrDefault("name")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "name", valid_594158
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
  var valid_594159 = query.getOrDefault("upload_protocol")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "upload_protocol", valid_594159
  var valid_594160 = query.getOrDefault("fields")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "fields", valid_594160
  var valid_594161 = query.getOrDefault("quotaUser")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "quotaUser", valid_594161
  var valid_594162 = query.getOrDefault("alt")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = newJString("json"))
  if valid_594162 != nil:
    section.add "alt", valid_594162
  var valid_594163 = query.getOrDefault("oauth_token")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "oauth_token", valid_594163
  var valid_594164 = query.getOrDefault("callback")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "callback", valid_594164
  var valid_594165 = query.getOrDefault("access_token")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "access_token", valid_594165
  var valid_594166 = query.getOrDefault("uploadType")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "uploadType", valid_594166
  var valid_594167 = query.getOrDefault("key")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "key", valid_594167
  var valid_594168 = query.getOrDefault("$.xgafv")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = newJString("1"))
  if valid_594168 != nil:
    section.add "$.xgafv", valid_594168
  var valid_594169 = query.getOrDefault("prettyPrint")
  valid_594169 = validateParameter(valid_594169, JBool, required = false,
                                 default = newJBool(true))
  if valid_594169 != nil:
    section.add "prettyPrint", valid_594169
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

proc call*(call_594171: Call_RunNamespacesConfigurationsReplaceConfiguration_594155;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace a configuration.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_RunNamespacesConfigurationsReplaceConfiguration_594155;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesConfigurationsReplaceConfiguration
  ## Replace a configuration.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  var body_594175 = newJObject()
  add(query_594174, "upload_protocol", newJString(uploadProtocol))
  add(query_594174, "fields", newJString(fields))
  add(query_594174, "quotaUser", newJString(quotaUser))
  add(path_594173, "name", newJString(name))
  add(query_594174, "alt", newJString(alt))
  add(query_594174, "oauth_token", newJString(oauthToken))
  add(query_594174, "callback", newJString(callback))
  add(query_594174, "access_token", newJString(accessToken))
  add(query_594174, "uploadType", newJString(uploadType))
  add(query_594174, "key", newJString(key))
  add(query_594174, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594175 = body
  add(query_594174, "prettyPrint", newJBool(prettyPrint))
  result = call_594172.call(path_594173, query_594174, nil, nil, body_594175)

var runNamespacesConfigurationsReplaceConfiguration* = Call_RunNamespacesConfigurationsReplaceConfiguration_594155(
    name: "runNamespacesConfigurationsReplaceConfiguration",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsReplaceConfiguration_594156,
    base: "/", url: url_RunNamespacesConfigurationsReplaceConfiguration_594157,
    schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsGet_594136 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesConfigurationsGet_594138(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsGet_594137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594139 = path.getOrDefault("name")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "name", valid_594139
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
  var valid_594140 = query.getOrDefault("upload_protocol")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "upload_protocol", valid_594140
  var valid_594141 = query.getOrDefault("fields")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "fields", valid_594141
  var valid_594142 = query.getOrDefault("quotaUser")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "quotaUser", valid_594142
  var valid_594143 = query.getOrDefault("alt")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = newJString("json"))
  if valid_594143 != nil:
    section.add "alt", valid_594143
  var valid_594144 = query.getOrDefault("oauth_token")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "oauth_token", valid_594144
  var valid_594145 = query.getOrDefault("callback")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "callback", valid_594145
  var valid_594146 = query.getOrDefault("access_token")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "access_token", valid_594146
  var valid_594147 = query.getOrDefault("uploadType")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "uploadType", valid_594147
  var valid_594148 = query.getOrDefault("key")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "key", valid_594148
  var valid_594149 = query.getOrDefault("$.xgafv")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = newJString("1"))
  if valid_594149 != nil:
    section.add "$.xgafv", valid_594149
  var valid_594150 = query.getOrDefault("prettyPrint")
  valid_594150 = validateParameter(valid_594150, JBool, required = false,
                                 default = newJBool(true))
  if valid_594150 != nil:
    section.add "prettyPrint", valid_594150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594151: Call_RunNamespacesConfigurationsGet_594136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a configuration.
  ## 
  let valid = call_594151.validator(path, query, header, formData, body)
  let scheme = call_594151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594151.url(scheme.get, call_594151.host, call_594151.base,
                         call_594151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594151, url, valid)

proc call*(call_594152: Call_RunNamespacesConfigurationsGet_594136; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runNamespacesConfigurationsGet
  ## Get information about a configuration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594153 = newJObject()
  var query_594154 = newJObject()
  add(query_594154, "upload_protocol", newJString(uploadProtocol))
  add(query_594154, "fields", newJString(fields))
  add(query_594154, "quotaUser", newJString(quotaUser))
  add(path_594153, "name", newJString(name))
  add(query_594154, "alt", newJString(alt))
  add(query_594154, "oauth_token", newJString(oauthToken))
  add(query_594154, "callback", newJString(callback))
  add(query_594154, "access_token", newJString(accessToken))
  add(query_594154, "uploadType", newJString(uploadType))
  add(query_594154, "key", newJString(key))
  add(query_594154, "$.xgafv", newJString(Xgafv))
  add(query_594154, "prettyPrint", newJBool(prettyPrint))
  result = call_594152.call(path_594153, query_594154, nil, nil, nil)

var runNamespacesConfigurationsGet* = Call_RunNamespacesConfigurationsGet_594136(
    name: "runNamespacesConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsGet_594137, base: "/",
    url: url_RunNamespacesConfigurationsGet_594138, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsDelete_594176 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesConfigurationsDelete_594178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsDelete_594177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the configuration being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594179 = path.getOrDefault("name")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "name", valid_594179
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
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  section = newJObject()
  var valid_594180 = query.getOrDefault("upload_protocol")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "upload_protocol", valid_594180
  var valid_594181 = query.getOrDefault("fields")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "fields", valid_594181
  var valid_594182 = query.getOrDefault("quotaUser")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "quotaUser", valid_594182
  var valid_594183 = query.getOrDefault("alt")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = newJString("json"))
  if valid_594183 != nil:
    section.add "alt", valid_594183
  var valid_594184 = query.getOrDefault("oauth_token")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "oauth_token", valid_594184
  var valid_594185 = query.getOrDefault("callback")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "callback", valid_594185
  var valid_594186 = query.getOrDefault("access_token")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "access_token", valid_594186
  var valid_594187 = query.getOrDefault("uploadType")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "uploadType", valid_594187
  var valid_594188 = query.getOrDefault("kind")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "kind", valid_594188
  var valid_594189 = query.getOrDefault("key")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "key", valid_594189
  var valid_594190 = query.getOrDefault("$.xgafv")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = newJString("1"))
  if valid_594190 != nil:
    section.add "$.xgafv", valid_594190
  var valid_594191 = query.getOrDefault("prettyPrint")
  valid_594191 = validateParameter(valid_594191, JBool, required = false,
                                 default = newJBool(true))
  if valid_594191 != nil:
    section.add "prettyPrint", valid_594191
  var valid_594192 = query.getOrDefault("propagationPolicy")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "propagationPolicy", valid_594192
  var valid_594193 = query.getOrDefault("apiVersion")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "apiVersion", valid_594193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594194: Call_RunNamespacesConfigurationsDelete_594176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
  ## 
  let valid = call_594194.validator(path, query, header, formData, body)
  let scheme = call_594194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594194.url(scheme.get, call_594194.host, call_594194.base,
                         call_594194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594194, url, valid)

proc call*(call_594195: Call_RunNamespacesConfigurationsDelete_594176;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runNamespacesConfigurationsDelete
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the configuration being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  var path_594196 = newJObject()
  var query_594197 = newJObject()
  add(query_594197, "upload_protocol", newJString(uploadProtocol))
  add(query_594197, "fields", newJString(fields))
  add(query_594197, "quotaUser", newJString(quotaUser))
  add(path_594196, "name", newJString(name))
  add(query_594197, "alt", newJString(alt))
  add(query_594197, "oauth_token", newJString(oauthToken))
  add(query_594197, "callback", newJString(callback))
  add(query_594197, "access_token", newJString(accessToken))
  add(query_594197, "uploadType", newJString(uploadType))
  add(query_594197, "kind", newJString(kind))
  add(query_594197, "key", newJString(key))
  add(query_594197, "$.xgafv", newJString(Xgafv))
  add(query_594197, "prettyPrint", newJBool(prettyPrint))
  add(query_594197, "propagationPolicy", newJString(propagationPolicy))
  add(query_594197, "apiVersion", newJString(apiVersion))
  result = call_594195.call(path_594196, query_594197, nil, nil, nil)

var runNamespacesConfigurationsDelete* = Call_RunNamespacesConfigurationsDelete_594176(
    name: "runNamespacesConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsDelete_594177, base: "/",
    url: url_RunNamespacesConfigurationsDelete_594178, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsCreate_594224 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesConfigurationsCreate_594226(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsCreate_594225(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this configuration should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594227 = path.getOrDefault("parent")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "parent", valid_594227
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
  var valid_594228 = query.getOrDefault("upload_protocol")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "upload_protocol", valid_594228
  var valid_594229 = query.getOrDefault("fields")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "fields", valid_594229
  var valid_594230 = query.getOrDefault("quotaUser")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "quotaUser", valid_594230
  var valid_594231 = query.getOrDefault("alt")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = newJString("json"))
  if valid_594231 != nil:
    section.add "alt", valid_594231
  var valid_594232 = query.getOrDefault("oauth_token")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "oauth_token", valid_594232
  var valid_594233 = query.getOrDefault("callback")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "callback", valid_594233
  var valid_594234 = query.getOrDefault("access_token")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "access_token", valid_594234
  var valid_594235 = query.getOrDefault("uploadType")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "uploadType", valid_594235
  var valid_594236 = query.getOrDefault("key")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "key", valid_594236
  var valid_594237 = query.getOrDefault("$.xgafv")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = newJString("1"))
  if valid_594237 != nil:
    section.add "$.xgafv", valid_594237
  var valid_594238 = query.getOrDefault("prettyPrint")
  valid_594238 = validateParameter(valid_594238, JBool, required = false,
                                 default = newJBool(true))
  if valid_594238 != nil:
    section.add "prettyPrint", valid_594238
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

proc call*(call_594240: Call_RunNamespacesConfigurationsCreate_594224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a configuration.
  ## 
  let valid = call_594240.validator(path, query, header, formData, body)
  let scheme = call_594240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594240.url(scheme.get, call_594240.host, call_594240.base,
                         call_594240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594240, url, valid)

proc call*(call_594241: Call_RunNamespacesConfigurationsCreate_594224;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesConfigurationsCreate
  ## Create a configuration.
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
  ##   parent: string (required)
  ##         : The project ID or project number in which this configuration should be
  ## created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594242 = newJObject()
  var query_594243 = newJObject()
  var body_594244 = newJObject()
  add(query_594243, "upload_protocol", newJString(uploadProtocol))
  add(query_594243, "fields", newJString(fields))
  add(query_594243, "quotaUser", newJString(quotaUser))
  add(query_594243, "alt", newJString(alt))
  add(query_594243, "oauth_token", newJString(oauthToken))
  add(query_594243, "callback", newJString(callback))
  add(query_594243, "access_token", newJString(accessToken))
  add(query_594243, "uploadType", newJString(uploadType))
  add(path_594242, "parent", newJString(parent))
  add(query_594243, "key", newJString(key))
  add(query_594243, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594244 = body
  add(query_594243, "prettyPrint", newJBool(prettyPrint))
  result = call_594241.call(path_594242, query_594243, nil, nil, body_594244)

var runNamespacesConfigurationsCreate* = Call_RunNamespacesConfigurationsCreate_594224(
    name: "runNamespacesConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsCreate_594225, base: "/",
    url: url_RunNamespacesConfigurationsCreate_594226, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsList_594198 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesConfigurationsList_594200(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsList_594199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594201 = path.getOrDefault("parent")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "parent", valid_594201
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594202 = query.getOrDefault("upload_protocol")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "upload_protocol", valid_594202
  var valid_594203 = query.getOrDefault("fields")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "fields", valid_594203
  var valid_594204 = query.getOrDefault("quotaUser")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "quotaUser", valid_594204
  var valid_594205 = query.getOrDefault("includeUninitialized")
  valid_594205 = validateParameter(valid_594205, JBool, required = false, default = nil)
  if valid_594205 != nil:
    section.add "includeUninitialized", valid_594205
  var valid_594206 = query.getOrDefault("alt")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = newJString("json"))
  if valid_594206 != nil:
    section.add "alt", valid_594206
  var valid_594207 = query.getOrDefault("continue")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "continue", valid_594207
  var valid_594208 = query.getOrDefault("oauth_token")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "oauth_token", valid_594208
  var valid_594209 = query.getOrDefault("callback")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "callback", valid_594209
  var valid_594210 = query.getOrDefault("access_token")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "access_token", valid_594210
  var valid_594211 = query.getOrDefault("uploadType")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "uploadType", valid_594211
  var valid_594212 = query.getOrDefault("resourceVersion")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "resourceVersion", valid_594212
  var valid_594213 = query.getOrDefault("watch")
  valid_594213 = validateParameter(valid_594213, JBool, required = false, default = nil)
  if valid_594213 != nil:
    section.add "watch", valid_594213
  var valid_594214 = query.getOrDefault("key")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "key", valid_594214
  var valid_594215 = query.getOrDefault("$.xgafv")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = newJString("1"))
  if valid_594215 != nil:
    section.add "$.xgafv", valid_594215
  var valid_594216 = query.getOrDefault("labelSelector")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "labelSelector", valid_594216
  var valid_594217 = query.getOrDefault("prettyPrint")
  valid_594217 = validateParameter(valid_594217, JBool, required = false,
                                 default = newJBool(true))
  if valid_594217 != nil:
    section.add "prettyPrint", valid_594217
  var valid_594218 = query.getOrDefault("fieldSelector")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "fieldSelector", valid_594218
  var valid_594219 = query.getOrDefault("limit")
  valid_594219 = validateParameter(valid_594219, JInt, required = false, default = nil)
  if valid_594219 != nil:
    section.add "limit", valid_594219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594220: Call_RunNamespacesConfigurationsList_594198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurations.
  ## 
  let valid = call_594220.validator(path, query, header, formData, body)
  let scheme = call_594220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594220.url(scheme.get, call_594220.host, call_594220.base,
                         call_594220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594220, url, valid)

proc call*(call_594221: Call_RunNamespacesConfigurationsList_594198;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesConfigurationsList
  ## List configurations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594222 = newJObject()
  var query_594223 = newJObject()
  add(query_594223, "upload_protocol", newJString(uploadProtocol))
  add(query_594223, "fields", newJString(fields))
  add(query_594223, "quotaUser", newJString(quotaUser))
  add(query_594223, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594223, "alt", newJString(alt))
  add(query_594223, "continue", newJString(`continue`))
  add(query_594223, "oauth_token", newJString(oauthToken))
  add(query_594223, "callback", newJString(callback))
  add(query_594223, "access_token", newJString(accessToken))
  add(query_594223, "uploadType", newJString(uploadType))
  add(path_594222, "parent", newJString(parent))
  add(query_594223, "resourceVersion", newJString(resourceVersion))
  add(query_594223, "watch", newJBool(watch))
  add(query_594223, "key", newJString(key))
  add(query_594223, "$.xgafv", newJString(Xgafv))
  add(query_594223, "labelSelector", newJString(labelSelector))
  add(query_594223, "prettyPrint", newJBool(prettyPrint))
  add(query_594223, "fieldSelector", newJString(fieldSelector))
  add(query_594223, "limit", newJInt(limit))
  result = call_594221.call(path_594222, query_594223, nil, nil, nil)

var runNamespacesConfigurationsList* = Call_RunNamespacesConfigurationsList_594198(
    name: "runNamespacesConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsList_594199, base: "/",
    url: url_RunNamespacesConfigurationsList_594200, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsList_594245 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesRevisionsList_594247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesRevisionsList_594246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the revisions should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594248 = path.getOrDefault("parent")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "parent", valid_594248
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594249 = query.getOrDefault("upload_protocol")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "upload_protocol", valid_594249
  var valid_594250 = query.getOrDefault("fields")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "fields", valid_594250
  var valid_594251 = query.getOrDefault("quotaUser")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "quotaUser", valid_594251
  var valid_594252 = query.getOrDefault("includeUninitialized")
  valid_594252 = validateParameter(valid_594252, JBool, required = false, default = nil)
  if valid_594252 != nil:
    section.add "includeUninitialized", valid_594252
  var valid_594253 = query.getOrDefault("alt")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = newJString("json"))
  if valid_594253 != nil:
    section.add "alt", valid_594253
  var valid_594254 = query.getOrDefault("continue")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "continue", valid_594254
  var valid_594255 = query.getOrDefault("oauth_token")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "oauth_token", valid_594255
  var valid_594256 = query.getOrDefault("callback")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "callback", valid_594256
  var valid_594257 = query.getOrDefault("access_token")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "access_token", valid_594257
  var valid_594258 = query.getOrDefault("uploadType")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "uploadType", valid_594258
  var valid_594259 = query.getOrDefault("resourceVersion")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "resourceVersion", valid_594259
  var valid_594260 = query.getOrDefault("watch")
  valid_594260 = validateParameter(valid_594260, JBool, required = false, default = nil)
  if valid_594260 != nil:
    section.add "watch", valid_594260
  var valid_594261 = query.getOrDefault("key")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "key", valid_594261
  var valid_594262 = query.getOrDefault("$.xgafv")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = newJString("1"))
  if valid_594262 != nil:
    section.add "$.xgafv", valid_594262
  var valid_594263 = query.getOrDefault("labelSelector")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "labelSelector", valid_594263
  var valid_594264 = query.getOrDefault("prettyPrint")
  valid_594264 = validateParameter(valid_594264, JBool, required = false,
                                 default = newJBool(true))
  if valid_594264 != nil:
    section.add "prettyPrint", valid_594264
  var valid_594265 = query.getOrDefault("fieldSelector")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "fieldSelector", valid_594265
  var valid_594266 = query.getOrDefault("limit")
  valid_594266 = validateParameter(valid_594266, JInt, required = false, default = nil)
  if valid_594266 != nil:
    section.add "limit", valid_594266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594267: Call_RunNamespacesRevisionsList_594245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List revisions.
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_RunNamespacesRevisionsList_594245; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesRevisionsList
  ## List revisions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the revisions should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594269 = newJObject()
  var query_594270 = newJObject()
  add(query_594270, "upload_protocol", newJString(uploadProtocol))
  add(query_594270, "fields", newJString(fields))
  add(query_594270, "quotaUser", newJString(quotaUser))
  add(query_594270, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594270, "alt", newJString(alt))
  add(query_594270, "continue", newJString(`continue`))
  add(query_594270, "oauth_token", newJString(oauthToken))
  add(query_594270, "callback", newJString(callback))
  add(query_594270, "access_token", newJString(accessToken))
  add(query_594270, "uploadType", newJString(uploadType))
  add(path_594269, "parent", newJString(parent))
  add(query_594270, "resourceVersion", newJString(resourceVersion))
  add(query_594270, "watch", newJBool(watch))
  add(query_594270, "key", newJString(key))
  add(query_594270, "$.xgafv", newJString(Xgafv))
  add(query_594270, "labelSelector", newJString(labelSelector))
  add(query_594270, "prettyPrint", newJBool(prettyPrint))
  add(query_594270, "fieldSelector", newJString(fieldSelector))
  add(query_594270, "limit", newJInt(limit))
  result = call_594268.call(path_594269, query_594270, nil, nil, nil)

var runNamespacesRevisionsList* = Call_RunNamespacesRevisionsList_594245(
    name: "runNamespacesRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/revisions",
    validator: validate_RunNamespacesRevisionsList_594246, base: "/",
    url: url_RunNamespacesRevisionsList_594247, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesCreate_594297 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesRoutesCreate_594299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesRoutesCreate_594298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a route.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this route should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594300 = path.getOrDefault("parent")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "parent", valid_594300
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
  var valid_594301 = query.getOrDefault("upload_protocol")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "upload_protocol", valid_594301
  var valid_594302 = query.getOrDefault("fields")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "fields", valid_594302
  var valid_594303 = query.getOrDefault("quotaUser")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "quotaUser", valid_594303
  var valid_594304 = query.getOrDefault("alt")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = newJString("json"))
  if valid_594304 != nil:
    section.add "alt", valid_594304
  var valid_594305 = query.getOrDefault("oauth_token")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "oauth_token", valid_594305
  var valid_594306 = query.getOrDefault("callback")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "callback", valid_594306
  var valid_594307 = query.getOrDefault("access_token")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "access_token", valid_594307
  var valid_594308 = query.getOrDefault("uploadType")
  valid_594308 = validateParameter(valid_594308, JString, required = false,
                                 default = nil)
  if valid_594308 != nil:
    section.add "uploadType", valid_594308
  var valid_594309 = query.getOrDefault("key")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "key", valid_594309
  var valid_594310 = query.getOrDefault("$.xgafv")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = newJString("1"))
  if valid_594310 != nil:
    section.add "$.xgafv", valid_594310
  var valid_594311 = query.getOrDefault("prettyPrint")
  valid_594311 = validateParameter(valid_594311, JBool, required = false,
                                 default = newJBool(true))
  if valid_594311 != nil:
    section.add "prettyPrint", valid_594311
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

proc call*(call_594313: Call_RunNamespacesRoutesCreate_594297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a route.
  ## 
  let valid = call_594313.validator(path, query, header, formData, body)
  let scheme = call_594313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594313.url(scheme.get, call_594313.host, call_594313.base,
                         call_594313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594313, url, valid)

proc call*(call_594314: Call_RunNamespacesRoutesCreate_594297; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## runNamespacesRoutesCreate
  ## Create a route.
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
  ##   parent: string (required)
  ##         : The project ID or project number in which this route should be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594315 = newJObject()
  var query_594316 = newJObject()
  var body_594317 = newJObject()
  add(query_594316, "upload_protocol", newJString(uploadProtocol))
  add(query_594316, "fields", newJString(fields))
  add(query_594316, "quotaUser", newJString(quotaUser))
  add(query_594316, "alt", newJString(alt))
  add(query_594316, "oauth_token", newJString(oauthToken))
  add(query_594316, "callback", newJString(callback))
  add(query_594316, "access_token", newJString(accessToken))
  add(query_594316, "uploadType", newJString(uploadType))
  add(path_594315, "parent", newJString(parent))
  add(query_594316, "key", newJString(key))
  add(query_594316, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594317 = body
  add(query_594316, "prettyPrint", newJBool(prettyPrint))
  result = call_594314.call(path_594315, query_594316, nil, nil, body_594317)

var runNamespacesRoutesCreate* = Call_RunNamespacesRoutesCreate_594297(
    name: "runNamespacesRoutesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/routes",
    validator: validate_RunNamespacesRoutesCreate_594298, base: "/",
    url: url_RunNamespacesRoutesCreate_594299, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesList_594271 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesRoutesList_594273(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesRoutesList_594272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List routes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the routes should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594274 = path.getOrDefault("parent")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "parent", valid_594274
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594275 = query.getOrDefault("upload_protocol")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "upload_protocol", valid_594275
  var valid_594276 = query.getOrDefault("fields")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "fields", valid_594276
  var valid_594277 = query.getOrDefault("quotaUser")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "quotaUser", valid_594277
  var valid_594278 = query.getOrDefault("includeUninitialized")
  valid_594278 = validateParameter(valid_594278, JBool, required = false, default = nil)
  if valid_594278 != nil:
    section.add "includeUninitialized", valid_594278
  var valid_594279 = query.getOrDefault("alt")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = newJString("json"))
  if valid_594279 != nil:
    section.add "alt", valid_594279
  var valid_594280 = query.getOrDefault("continue")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "continue", valid_594280
  var valid_594281 = query.getOrDefault("oauth_token")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "oauth_token", valid_594281
  var valid_594282 = query.getOrDefault("callback")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "callback", valid_594282
  var valid_594283 = query.getOrDefault("access_token")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "access_token", valid_594283
  var valid_594284 = query.getOrDefault("uploadType")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "uploadType", valid_594284
  var valid_594285 = query.getOrDefault("resourceVersion")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "resourceVersion", valid_594285
  var valid_594286 = query.getOrDefault("watch")
  valid_594286 = validateParameter(valid_594286, JBool, required = false, default = nil)
  if valid_594286 != nil:
    section.add "watch", valid_594286
  var valid_594287 = query.getOrDefault("key")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "key", valid_594287
  var valid_594288 = query.getOrDefault("$.xgafv")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = newJString("1"))
  if valid_594288 != nil:
    section.add "$.xgafv", valid_594288
  var valid_594289 = query.getOrDefault("labelSelector")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "labelSelector", valid_594289
  var valid_594290 = query.getOrDefault("prettyPrint")
  valid_594290 = validateParameter(valid_594290, JBool, required = false,
                                 default = newJBool(true))
  if valid_594290 != nil:
    section.add "prettyPrint", valid_594290
  var valid_594291 = query.getOrDefault("fieldSelector")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "fieldSelector", valid_594291
  var valid_594292 = query.getOrDefault("limit")
  valid_594292 = validateParameter(valid_594292, JInt, required = false, default = nil)
  if valid_594292 != nil:
    section.add "limit", valid_594292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594293: Call_RunNamespacesRoutesList_594271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List routes.
  ## 
  let valid = call_594293.validator(path, query, header, formData, body)
  let scheme = call_594293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594293.url(scheme.get, call_594293.host, call_594293.base,
                         call_594293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594293, url, valid)

proc call*(call_594294: Call_RunNamespacesRoutesList_594271; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesRoutesList
  ## List routes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the routes should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594295 = newJObject()
  var query_594296 = newJObject()
  add(query_594296, "upload_protocol", newJString(uploadProtocol))
  add(query_594296, "fields", newJString(fields))
  add(query_594296, "quotaUser", newJString(quotaUser))
  add(query_594296, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594296, "alt", newJString(alt))
  add(query_594296, "continue", newJString(`continue`))
  add(query_594296, "oauth_token", newJString(oauthToken))
  add(query_594296, "callback", newJString(callback))
  add(query_594296, "access_token", newJString(accessToken))
  add(query_594296, "uploadType", newJString(uploadType))
  add(path_594295, "parent", newJString(parent))
  add(query_594296, "resourceVersion", newJString(resourceVersion))
  add(query_594296, "watch", newJBool(watch))
  add(query_594296, "key", newJString(key))
  add(query_594296, "$.xgafv", newJString(Xgafv))
  add(query_594296, "labelSelector", newJString(labelSelector))
  add(query_594296, "prettyPrint", newJBool(prettyPrint))
  add(query_594296, "fieldSelector", newJString(fieldSelector))
  add(query_594296, "limit", newJInt(limit))
  result = call_594294.call(path_594295, query_594296, nil, nil, nil)

var runNamespacesRoutesList* = Call_RunNamespacesRoutesList_594271(
    name: "runNamespacesRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/routes",
    validator: validate_RunNamespacesRoutesList_594272, base: "/",
    url: url_RunNamespacesRoutesList_594273, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesCreate_594344 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesServicesCreate_594346(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesCreate_594345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this service should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594347 = path.getOrDefault("parent")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "parent", valid_594347
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
  var valid_594348 = query.getOrDefault("upload_protocol")
  valid_594348 = validateParameter(valid_594348, JString, required = false,
                                 default = nil)
  if valid_594348 != nil:
    section.add "upload_protocol", valid_594348
  var valid_594349 = query.getOrDefault("fields")
  valid_594349 = validateParameter(valid_594349, JString, required = false,
                                 default = nil)
  if valid_594349 != nil:
    section.add "fields", valid_594349
  var valid_594350 = query.getOrDefault("quotaUser")
  valid_594350 = validateParameter(valid_594350, JString, required = false,
                                 default = nil)
  if valid_594350 != nil:
    section.add "quotaUser", valid_594350
  var valid_594351 = query.getOrDefault("alt")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = newJString("json"))
  if valid_594351 != nil:
    section.add "alt", valid_594351
  var valid_594352 = query.getOrDefault("oauth_token")
  valid_594352 = validateParameter(valid_594352, JString, required = false,
                                 default = nil)
  if valid_594352 != nil:
    section.add "oauth_token", valid_594352
  var valid_594353 = query.getOrDefault("callback")
  valid_594353 = validateParameter(valid_594353, JString, required = false,
                                 default = nil)
  if valid_594353 != nil:
    section.add "callback", valid_594353
  var valid_594354 = query.getOrDefault("access_token")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "access_token", valid_594354
  var valid_594355 = query.getOrDefault("uploadType")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "uploadType", valid_594355
  var valid_594356 = query.getOrDefault("key")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "key", valid_594356
  var valid_594357 = query.getOrDefault("$.xgafv")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = newJString("1"))
  if valid_594357 != nil:
    section.add "$.xgafv", valid_594357
  var valid_594358 = query.getOrDefault("prettyPrint")
  valid_594358 = validateParameter(valid_594358, JBool, required = false,
                                 default = newJBool(true))
  if valid_594358 != nil:
    section.add "prettyPrint", valid_594358
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

proc call*(call_594360: Call_RunNamespacesServicesCreate_594344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a service.
  ## 
  let valid = call_594360.validator(path, query, header, formData, body)
  let scheme = call_594360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594360.url(scheme.get, call_594360.host, call_594360.base,
                         call_594360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594360, url, valid)

proc call*(call_594361: Call_RunNamespacesServicesCreate_594344; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## runNamespacesServicesCreate
  ## Create a service.
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
  ##   parent: string (required)
  ##         : The project ID or project number in which this service should be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594362 = newJObject()
  var query_594363 = newJObject()
  var body_594364 = newJObject()
  add(query_594363, "upload_protocol", newJString(uploadProtocol))
  add(query_594363, "fields", newJString(fields))
  add(query_594363, "quotaUser", newJString(quotaUser))
  add(query_594363, "alt", newJString(alt))
  add(query_594363, "oauth_token", newJString(oauthToken))
  add(query_594363, "callback", newJString(callback))
  add(query_594363, "access_token", newJString(accessToken))
  add(query_594363, "uploadType", newJString(uploadType))
  add(path_594362, "parent", newJString(parent))
  add(query_594363, "key", newJString(key))
  add(query_594363, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594364 = body
  add(query_594363, "prettyPrint", newJBool(prettyPrint))
  result = call_594361.call(path_594362, query_594363, nil, nil, body_594364)

var runNamespacesServicesCreate* = Call_RunNamespacesServicesCreate_594344(
    name: "runNamespacesServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/services",
    validator: validate_RunNamespacesServicesCreate_594345, base: "/",
    url: url_RunNamespacesServicesCreate_594346, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesList_594318 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesServicesList_594320(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesList_594319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the services should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594321 = path.getOrDefault("parent")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "parent", valid_594321
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594322 = query.getOrDefault("upload_protocol")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "upload_protocol", valid_594322
  var valid_594323 = query.getOrDefault("fields")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "fields", valid_594323
  var valid_594324 = query.getOrDefault("quotaUser")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "quotaUser", valid_594324
  var valid_594325 = query.getOrDefault("includeUninitialized")
  valid_594325 = validateParameter(valid_594325, JBool, required = false, default = nil)
  if valid_594325 != nil:
    section.add "includeUninitialized", valid_594325
  var valid_594326 = query.getOrDefault("alt")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = newJString("json"))
  if valid_594326 != nil:
    section.add "alt", valid_594326
  var valid_594327 = query.getOrDefault("continue")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "continue", valid_594327
  var valid_594328 = query.getOrDefault("oauth_token")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "oauth_token", valid_594328
  var valid_594329 = query.getOrDefault("callback")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "callback", valid_594329
  var valid_594330 = query.getOrDefault("access_token")
  valid_594330 = validateParameter(valid_594330, JString, required = false,
                                 default = nil)
  if valid_594330 != nil:
    section.add "access_token", valid_594330
  var valid_594331 = query.getOrDefault("uploadType")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = nil)
  if valid_594331 != nil:
    section.add "uploadType", valid_594331
  var valid_594332 = query.getOrDefault("resourceVersion")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "resourceVersion", valid_594332
  var valid_594333 = query.getOrDefault("watch")
  valid_594333 = validateParameter(valid_594333, JBool, required = false, default = nil)
  if valid_594333 != nil:
    section.add "watch", valid_594333
  var valid_594334 = query.getOrDefault("key")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = nil)
  if valid_594334 != nil:
    section.add "key", valid_594334
  var valid_594335 = query.getOrDefault("$.xgafv")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = newJString("1"))
  if valid_594335 != nil:
    section.add "$.xgafv", valid_594335
  var valid_594336 = query.getOrDefault("labelSelector")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "labelSelector", valid_594336
  var valid_594337 = query.getOrDefault("prettyPrint")
  valid_594337 = validateParameter(valid_594337, JBool, required = false,
                                 default = newJBool(true))
  if valid_594337 != nil:
    section.add "prettyPrint", valid_594337
  var valid_594338 = query.getOrDefault("fieldSelector")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "fieldSelector", valid_594338
  var valid_594339 = query.getOrDefault("limit")
  valid_594339 = validateParameter(valid_594339, JInt, required = false, default = nil)
  if valid_594339 != nil:
    section.add "limit", valid_594339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594340: Call_RunNamespacesServicesList_594318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List services.
  ## 
  let valid = call_594340.validator(path, query, header, formData, body)
  let scheme = call_594340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594340.url(scheme.get, call_594340.host, call_594340.base,
                         call_594340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594340, url, valid)

proc call*(call_594341: Call_RunNamespacesServicesList_594318; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesServicesList
  ## List services.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the services should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594342 = newJObject()
  var query_594343 = newJObject()
  add(query_594343, "upload_protocol", newJString(uploadProtocol))
  add(query_594343, "fields", newJString(fields))
  add(query_594343, "quotaUser", newJString(quotaUser))
  add(query_594343, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594343, "alt", newJString(alt))
  add(query_594343, "continue", newJString(`continue`))
  add(query_594343, "oauth_token", newJString(oauthToken))
  add(query_594343, "callback", newJString(callback))
  add(query_594343, "access_token", newJString(accessToken))
  add(query_594343, "uploadType", newJString(uploadType))
  add(path_594342, "parent", newJString(parent))
  add(query_594343, "resourceVersion", newJString(resourceVersion))
  add(query_594343, "watch", newJBool(watch))
  add(query_594343, "key", newJString(key))
  add(query_594343, "$.xgafv", newJString(Xgafv))
  add(query_594343, "labelSelector", newJString(labelSelector))
  add(query_594343, "prettyPrint", newJBool(prettyPrint))
  add(query_594343, "fieldSelector", newJString(fieldSelector))
  add(query_594343, "limit", newJInt(limit))
  result = call_594341.call(path_594342, query_594343, nil, nil, nil)

var runNamespacesServicesList* = Call_RunNamespacesServicesList_594318(
    name: "runNamespacesServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/services",
    validator: validate_RunNamespacesServicesList_594319, base: "/",
    url: url_RunNamespacesServicesList_594320, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_594384 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsDomainmappingsReplaceDomainMapping_594386(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsReplaceDomainMapping_594385(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594387 = path.getOrDefault("name")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "name", valid_594387
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
  var valid_594388 = query.getOrDefault("upload_protocol")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "upload_protocol", valid_594388
  var valid_594389 = query.getOrDefault("fields")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = nil)
  if valid_594389 != nil:
    section.add "fields", valid_594389
  var valid_594390 = query.getOrDefault("quotaUser")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = nil)
  if valid_594390 != nil:
    section.add "quotaUser", valid_594390
  var valid_594391 = query.getOrDefault("alt")
  valid_594391 = validateParameter(valid_594391, JString, required = false,
                                 default = newJString("json"))
  if valid_594391 != nil:
    section.add "alt", valid_594391
  var valid_594392 = query.getOrDefault("oauth_token")
  valid_594392 = validateParameter(valid_594392, JString, required = false,
                                 default = nil)
  if valid_594392 != nil:
    section.add "oauth_token", valid_594392
  var valid_594393 = query.getOrDefault("callback")
  valid_594393 = validateParameter(valid_594393, JString, required = false,
                                 default = nil)
  if valid_594393 != nil:
    section.add "callback", valid_594393
  var valid_594394 = query.getOrDefault("access_token")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "access_token", valid_594394
  var valid_594395 = query.getOrDefault("uploadType")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = nil)
  if valid_594395 != nil:
    section.add "uploadType", valid_594395
  var valid_594396 = query.getOrDefault("key")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = nil)
  if valid_594396 != nil:
    section.add "key", valid_594396
  var valid_594397 = query.getOrDefault("$.xgafv")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = newJString("1"))
  if valid_594397 != nil:
    section.add "$.xgafv", valid_594397
  var valid_594398 = query.getOrDefault("prettyPrint")
  valid_594398 = validateParameter(valid_594398, JBool, required = false,
                                 default = newJBool(true))
  if valid_594398 != nil:
    section.add "prettyPrint", valid_594398
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

proc call*(call_594400: Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_594384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_594400.validator(path, query, header, formData, body)
  let scheme = call_594400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594400.url(scheme.get, call_594400.host, call_594400.base,
                         call_594400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594400, url, valid)

proc call*(call_594401: Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_594384;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsDomainmappingsReplaceDomainMapping
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_594402 = newJObject()
  var query_594403 = newJObject()
  var body_594404 = newJObject()
  add(query_594403, "upload_protocol", newJString(uploadProtocol))
  add(query_594403, "fields", newJString(fields))
  add(query_594403, "quotaUser", newJString(quotaUser))
  add(path_594402, "name", newJString(name))
  add(query_594403, "alt", newJString(alt))
  add(query_594403, "oauth_token", newJString(oauthToken))
  add(query_594403, "callback", newJString(callback))
  add(query_594403, "access_token", newJString(accessToken))
  add(query_594403, "uploadType", newJString(uploadType))
  add(query_594403, "key", newJString(key))
  add(query_594403, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594404 = body
  add(query_594403, "prettyPrint", newJBool(prettyPrint))
  result = call_594401.call(path_594402, query_594403, nil, nil, body_594404)

var runProjectsLocationsDomainmappingsReplaceDomainMapping* = Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_594384(
    name: "runProjectsLocationsDomainmappingsReplaceDomainMapping",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsReplaceDomainMapping_594385,
    base: "/", url: url_RunProjectsLocationsDomainmappingsReplaceDomainMapping_594386,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsGet_594365 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsDomainmappingsGet_594367(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsGet_594366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594368 = path.getOrDefault("name")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "name", valid_594368
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
  var valid_594369 = query.getOrDefault("upload_protocol")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = nil)
  if valid_594369 != nil:
    section.add "upload_protocol", valid_594369
  var valid_594370 = query.getOrDefault("fields")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = nil)
  if valid_594370 != nil:
    section.add "fields", valid_594370
  var valid_594371 = query.getOrDefault("quotaUser")
  valid_594371 = validateParameter(valid_594371, JString, required = false,
                                 default = nil)
  if valid_594371 != nil:
    section.add "quotaUser", valid_594371
  var valid_594372 = query.getOrDefault("alt")
  valid_594372 = validateParameter(valid_594372, JString, required = false,
                                 default = newJString("json"))
  if valid_594372 != nil:
    section.add "alt", valid_594372
  var valid_594373 = query.getOrDefault("oauth_token")
  valid_594373 = validateParameter(valid_594373, JString, required = false,
                                 default = nil)
  if valid_594373 != nil:
    section.add "oauth_token", valid_594373
  var valid_594374 = query.getOrDefault("callback")
  valid_594374 = validateParameter(valid_594374, JString, required = false,
                                 default = nil)
  if valid_594374 != nil:
    section.add "callback", valid_594374
  var valid_594375 = query.getOrDefault("access_token")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = nil)
  if valid_594375 != nil:
    section.add "access_token", valid_594375
  var valid_594376 = query.getOrDefault("uploadType")
  valid_594376 = validateParameter(valid_594376, JString, required = false,
                                 default = nil)
  if valid_594376 != nil:
    section.add "uploadType", valid_594376
  var valid_594377 = query.getOrDefault("key")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = nil)
  if valid_594377 != nil:
    section.add "key", valid_594377
  var valid_594378 = query.getOrDefault("$.xgafv")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = newJString("1"))
  if valid_594378 != nil:
    section.add "$.xgafv", valid_594378
  var valid_594379 = query.getOrDefault("prettyPrint")
  valid_594379 = validateParameter(valid_594379, JBool, required = false,
                                 default = newJBool(true))
  if valid_594379 != nil:
    section.add "prettyPrint", valid_594379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594380: Call_RunProjectsLocationsDomainmappingsGet_594365;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about a domain mapping.
  ## 
  let valid = call_594380.validator(path, query, header, formData, body)
  let scheme = call_594380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594380.url(scheme.get, call_594380.host, call_594380.base,
                         call_594380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594380, url, valid)

proc call*(call_594381: Call_RunProjectsLocationsDomainmappingsGet_594365;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsDomainmappingsGet
  ## Get information about a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594382 = newJObject()
  var query_594383 = newJObject()
  add(query_594383, "upload_protocol", newJString(uploadProtocol))
  add(query_594383, "fields", newJString(fields))
  add(query_594383, "quotaUser", newJString(quotaUser))
  add(path_594382, "name", newJString(name))
  add(query_594383, "alt", newJString(alt))
  add(query_594383, "oauth_token", newJString(oauthToken))
  add(query_594383, "callback", newJString(callback))
  add(query_594383, "access_token", newJString(accessToken))
  add(query_594383, "uploadType", newJString(uploadType))
  add(query_594383, "key", newJString(key))
  add(query_594383, "$.xgafv", newJString(Xgafv))
  add(query_594383, "prettyPrint", newJBool(prettyPrint))
  result = call_594381.call(path_594382, query_594383, nil, nil, nil)

var runProjectsLocationsDomainmappingsGet* = Call_RunProjectsLocationsDomainmappingsGet_594365(
    name: "runProjectsLocationsDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsGet_594366, base: "/",
    url: url_RunProjectsLocationsDomainmappingsGet_594367, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsDelete_594405 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsDomainmappingsDelete_594407(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsDelete_594406(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594408 = path.getOrDefault("name")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "name", valid_594408
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
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  section = newJObject()
  var valid_594409 = query.getOrDefault("upload_protocol")
  valid_594409 = validateParameter(valid_594409, JString, required = false,
                                 default = nil)
  if valid_594409 != nil:
    section.add "upload_protocol", valid_594409
  var valid_594410 = query.getOrDefault("fields")
  valid_594410 = validateParameter(valid_594410, JString, required = false,
                                 default = nil)
  if valid_594410 != nil:
    section.add "fields", valid_594410
  var valid_594411 = query.getOrDefault("quotaUser")
  valid_594411 = validateParameter(valid_594411, JString, required = false,
                                 default = nil)
  if valid_594411 != nil:
    section.add "quotaUser", valid_594411
  var valid_594412 = query.getOrDefault("alt")
  valid_594412 = validateParameter(valid_594412, JString, required = false,
                                 default = newJString("json"))
  if valid_594412 != nil:
    section.add "alt", valid_594412
  var valid_594413 = query.getOrDefault("oauth_token")
  valid_594413 = validateParameter(valid_594413, JString, required = false,
                                 default = nil)
  if valid_594413 != nil:
    section.add "oauth_token", valid_594413
  var valid_594414 = query.getOrDefault("callback")
  valid_594414 = validateParameter(valid_594414, JString, required = false,
                                 default = nil)
  if valid_594414 != nil:
    section.add "callback", valid_594414
  var valid_594415 = query.getOrDefault("access_token")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = nil)
  if valid_594415 != nil:
    section.add "access_token", valid_594415
  var valid_594416 = query.getOrDefault("uploadType")
  valid_594416 = validateParameter(valid_594416, JString, required = false,
                                 default = nil)
  if valid_594416 != nil:
    section.add "uploadType", valid_594416
  var valid_594417 = query.getOrDefault("kind")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "kind", valid_594417
  var valid_594418 = query.getOrDefault("key")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "key", valid_594418
  var valid_594419 = query.getOrDefault("$.xgafv")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = newJString("1"))
  if valid_594419 != nil:
    section.add "$.xgafv", valid_594419
  var valid_594420 = query.getOrDefault("prettyPrint")
  valid_594420 = validateParameter(valid_594420, JBool, required = false,
                                 default = newJBool(true))
  if valid_594420 != nil:
    section.add "prettyPrint", valid_594420
  var valid_594421 = query.getOrDefault("propagationPolicy")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "propagationPolicy", valid_594421
  var valid_594422 = query.getOrDefault("apiVersion")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "apiVersion", valid_594422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594423: Call_RunProjectsLocationsDomainmappingsDelete_594405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a domain mapping.
  ## 
  let valid = call_594423.validator(path, query, header, formData, body)
  let scheme = call_594423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594423.url(scheme.get, call_594423.host, call_594423.base,
                         call_594423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594423, url, valid)

proc call*(call_594424: Call_RunProjectsLocationsDomainmappingsDelete_594405;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsDelete
  ## Delete a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  var path_594425 = newJObject()
  var query_594426 = newJObject()
  add(query_594426, "upload_protocol", newJString(uploadProtocol))
  add(query_594426, "fields", newJString(fields))
  add(query_594426, "quotaUser", newJString(quotaUser))
  add(path_594425, "name", newJString(name))
  add(query_594426, "alt", newJString(alt))
  add(query_594426, "oauth_token", newJString(oauthToken))
  add(query_594426, "callback", newJString(callback))
  add(query_594426, "access_token", newJString(accessToken))
  add(query_594426, "uploadType", newJString(uploadType))
  add(query_594426, "kind", newJString(kind))
  add(query_594426, "key", newJString(key))
  add(query_594426, "$.xgafv", newJString(Xgafv))
  add(query_594426, "prettyPrint", newJBool(prettyPrint))
  add(query_594426, "propagationPolicy", newJString(propagationPolicy))
  add(query_594426, "apiVersion", newJString(apiVersion))
  result = call_594424.call(path_594425, query_594426, nil, nil, nil)

var runProjectsLocationsDomainmappingsDelete* = Call_RunProjectsLocationsDomainmappingsDelete_594405(
    name: "runProjectsLocationsDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsDelete_594406,
    base: "/", url: url_RunProjectsLocationsDomainmappingsDelete_594407,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsList_594427 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsList_594429(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsList_594428(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594430 = path.getOrDefault("name")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "name", valid_594430
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_594431 = query.getOrDefault("upload_protocol")
  valid_594431 = validateParameter(valid_594431, JString, required = false,
                                 default = nil)
  if valid_594431 != nil:
    section.add "upload_protocol", valid_594431
  var valid_594432 = query.getOrDefault("fields")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "fields", valid_594432
  var valid_594433 = query.getOrDefault("pageToken")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = nil)
  if valid_594433 != nil:
    section.add "pageToken", valid_594433
  var valid_594434 = query.getOrDefault("quotaUser")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = nil)
  if valid_594434 != nil:
    section.add "quotaUser", valid_594434
  var valid_594435 = query.getOrDefault("alt")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = newJString("json"))
  if valid_594435 != nil:
    section.add "alt", valid_594435
  var valid_594436 = query.getOrDefault("oauth_token")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "oauth_token", valid_594436
  var valid_594437 = query.getOrDefault("callback")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = nil)
  if valid_594437 != nil:
    section.add "callback", valid_594437
  var valid_594438 = query.getOrDefault("access_token")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = nil)
  if valid_594438 != nil:
    section.add "access_token", valid_594438
  var valid_594439 = query.getOrDefault("uploadType")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "uploadType", valid_594439
  var valid_594440 = query.getOrDefault("key")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = nil)
  if valid_594440 != nil:
    section.add "key", valid_594440
  var valid_594441 = query.getOrDefault("$.xgafv")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = newJString("1"))
  if valid_594441 != nil:
    section.add "$.xgafv", valid_594441
  var valid_594442 = query.getOrDefault("pageSize")
  valid_594442 = validateParameter(valid_594442, JInt, required = false, default = nil)
  if valid_594442 != nil:
    section.add "pageSize", valid_594442
  var valid_594443 = query.getOrDefault("prettyPrint")
  valid_594443 = validateParameter(valid_594443, JBool, required = false,
                                 default = newJBool(true))
  if valid_594443 != nil:
    section.add "prettyPrint", valid_594443
  var valid_594444 = query.getOrDefault("filter")
  valid_594444 = validateParameter(valid_594444, JString, required = false,
                                 default = nil)
  if valid_594444 != nil:
    section.add "filter", valid_594444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594445: Call_RunProjectsLocationsList_594427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_594445.validator(path, query, header, formData, body)
  let scheme = call_594445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594445.url(scheme.get, call_594445.host, call_594445.base,
                         call_594445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594445, url, valid)

proc call*(call_594446: Call_RunProjectsLocationsList_594427; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## runProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
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
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_594447 = newJObject()
  var query_594448 = newJObject()
  add(query_594448, "upload_protocol", newJString(uploadProtocol))
  add(query_594448, "fields", newJString(fields))
  add(query_594448, "pageToken", newJString(pageToken))
  add(query_594448, "quotaUser", newJString(quotaUser))
  add(path_594447, "name", newJString(name))
  add(query_594448, "alt", newJString(alt))
  add(query_594448, "oauth_token", newJString(oauthToken))
  add(query_594448, "callback", newJString(callback))
  add(query_594448, "access_token", newJString(accessToken))
  add(query_594448, "uploadType", newJString(uploadType))
  add(query_594448, "key", newJString(key))
  add(query_594448, "$.xgafv", newJString(Xgafv))
  add(query_594448, "pageSize", newJInt(pageSize))
  add(query_594448, "prettyPrint", newJBool(prettyPrint))
  add(query_594448, "filter", newJString(filter))
  result = call_594446.call(path_594447, query_594448, nil, nil, nil)

var runProjectsLocationsList* = Call_RunProjectsLocationsList_594427(
    name: "runProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_RunProjectsLocationsList_594428, base: "/",
    url: url_RunProjectsLocationsList_594429, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAuthorizeddomainsList_594449 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsAuthorizeddomainsList_594451(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/authorizeddomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsAuthorizeddomainsList_594450(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List authorized domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594452 = path.getOrDefault("parent")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "parent", valid_594452
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
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
  ##   pageSize: JInt
  ##           : Maximum results to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594453 = query.getOrDefault("upload_protocol")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "upload_protocol", valid_594453
  var valid_594454 = query.getOrDefault("fields")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "fields", valid_594454
  var valid_594455 = query.getOrDefault("pageToken")
  valid_594455 = validateParameter(valid_594455, JString, required = false,
                                 default = nil)
  if valid_594455 != nil:
    section.add "pageToken", valid_594455
  var valid_594456 = query.getOrDefault("quotaUser")
  valid_594456 = validateParameter(valid_594456, JString, required = false,
                                 default = nil)
  if valid_594456 != nil:
    section.add "quotaUser", valid_594456
  var valid_594457 = query.getOrDefault("alt")
  valid_594457 = validateParameter(valid_594457, JString, required = false,
                                 default = newJString("json"))
  if valid_594457 != nil:
    section.add "alt", valid_594457
  var valid_594458 = query.getOrDefault("oauth_token")
  valid_594458 = validateParameter(valid_594458, JString, required = false,
                                 default = nil)
  if valid_594458 != nil:
    section.add "oauth_token", valid_594458
  var valid_594459 = query.getOrDefault("callback")
  valid_594459 = validateParameter(valid_594459, JString, required = false,
                                 default = nil)
  if valid_594459 != nil:
    section.add "callback", valid_594459
  var valid_594460 = query.getOrDefault("access_token")
  valid_594460 = validateParameter(valid_594460, JString, required = false,
                                 default = nil)
  if valid_594460 != nil:
    section.add "access_token", valid_594460
  var valid_594461 = query.getOrDefault("uploadType")
  valid_594461 = validateParameter(valid_594461, JString, required = false,
                                 default = nil)
  if valid_594461 != nil:
    section.add "uploadType", valid_594461
  var valid_594462 = query.getOrDefault("key")
  valid_594462 = validateParameter(valid_594462, JString, required = false,
                                 default = nil)
  if valid_594462 != nil:
    section.add "key", valid_594462
  var valid_594463 = query.getOrDefault("$.xgafv")
  valid_594463 = validateParameter(valid_594463, JString, required = false,
                                 default = newJString("1"))
  if valid_594463 != nil:
    section.add "$.xgafv", valid_594463
  var valid_594464 = query.getOrDefault("pageSize")
  valid_594464 = validateParameter(valid_594464, JInt, required = false, default = nil)
  if valid_594464 != nil:
    section.add "pageSize", valid_594464
  var valid_594465 = query.getOrDefault("prettyPrint")
  valid_594465 = validateParameter(valid_594465, JBool, required = false,
                                 default = newJBool(true))
  if valid_594465 != nil:
    section.add "prettyPrint", valid_594465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594466: Call_RunProjectsLocationsAuthorizeddomainsList_594449;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List authorized domains.
  ## 
  let valid = call_594466.validator(path, query, header, formData, body)
  let scheme = call_594466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594466.url(scheme.get, call_594466.host, call_594466.base,
                         call_594466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594466, url, valid)

proc call*(call_594467: Call_RunProjectsLocationsAuthorizeddomainsList_594449;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsAuthorizeddomainsList
  ## List authorized domains.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
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
  ##   parent: string (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594468 = newJObject()
  var query_594469 = newJObject()
  add(query_594469, "upload_protocol", newJString(uploadProtocol))
  add(query_594469, "fields", newJString(fields))
  add(query_594469, "pageToken", newJString(pageToken))
  add(query_594469, "quotaUser", newJString(quotaUser))
  add(query_594469, "alt", newJString(alt))
  add(query_594469, "oauth_token", newJString(oauthToken))
  add(query_594469, "callback", newJString(callback))
  add(query_594469, "access_token", newJString(accessToken))
  add(query_594469, "uploadType", newJString(uploadType))
  add(path_594468, "parent", newJString(parent))
  add(query_594469, "key", newJString(key))
  add(query_594469, "$.xgafv", newJString(Xgafv))
  add(query_594469, "pageSize", newJInt(pageSize))
  add(query_594469, "prettyPrint", newJBool(prettyPrint))
  result = call_594467.call(path_594468, query_594469, nil, nil, nil)

var runProjectsLocationsAuthorizeddomainsList* = Call_RunProjectsLocationsAuthorizeddomainsList_594449(
    name: "runProjectsLocationsAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/authorizeddomains",
    validator: validate_RunProjectsLocationsAuthorizeddomainsList_594450,
    base: "/", url: url_RunProjectsLocationsAuthorizeddomainsList_594451,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAutodomainmappingsCreate_594496 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsAutodomainmappingsCreate_594498(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsAutodomainmappingsCreate_594497(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new auto domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594499 = path.getOrDefault("parent")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "parent", valid_594499
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
  var valid_594500 = query.getOrDefault("upload_protocol")
  valid_594500 = validateParameter(valid_594500, JString, required = false,
                                 default = nil)
  if valid_594500 != nil:
    section.add "upload_protocol", valid_594500
  var valid_594501 = query.getOrDefault("fields")
  valid_594501 = validateParameter(valid_594501, JString, required = false,
                                 default = nil)
  if valid_594501 != nil:
    section.add "fields", valid_594501
  var valid_594502 = query.getOrDefault("quotaUser")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = nil)
  if valid_594502 != nil:
    section.add "quotaUser", valid_594502
  var valid_594503 = query.getOrDefault("alt")
  valid_594503 = validateParameter(valid_594503, JString, required = false,
                                 default = newJString("json"))
  if valid_594503 != nil:
    section.add "alt", valid_594503
  var valid_594504 = query.getOrDefault("oauth_token")
  valid_594504 = validateParameter(valid_594504, JString, required = false,
                                 default = nil)
  if valid_594504 != nil:
    section.add "oauth_token", valid_594504
  var valid_594505 = query.getOrDefault("callback")
  valid_594505 = validateParameter(valid_594505, JString, required = false,
                                 default = nil)
  if valid_594505 != nil:
    section.add "callback", valid_594505
  var valid_594506 = query.getOrDefault("access_token")
  valid_594506 = validateParameter(valid_594506, JString, required = false,
                                 default = nil)
  if valid_594506 != nil:
    section.add "access_token", valid_594506
  var valid_594507 = query.getOrDefault("uploadType")
  valid_594507 = validateParameter(valid_594507, JString, required = false,
                                 default = nil)
  if valid_594507 != nil:
    section.add "uploadType", valid_594507
  var valid_594508 = query.getOrDefault("key")
  valid_594508 = validateParameter(valid_594508, JString, required = false,
                                 default = nil)
  if valid_594508 != nil:
    section.add "key", valid_594508
  var valid_594509 = query.getOrDefault("$.xgafv")
  valid_594509 = validateParameter(valid_594509, JString, required = false,
                                 default = newJString("1"))
  if valid_594509 != nil:
    section.add "$.xgafv", valid_594509
  var valid_594510 = query.getOrDefault("prettyPrint")
  valid_594510 = validateParameter(valid_594510, JBool, required = false,
                                 default = newJBool(true))
  if valid_594510 != nil:
    section.add "prettyPrint", valid_594510
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

proc call*(call_594512: Call_RunProjectsLocationsAutodomainmappingsCreate_594496;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new auto domain mapping.
  ## 
  let valid = call_594512.validator(path, query, header, formData, body)
  let scheme = call_594512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594512.url(scheme.get, call_594512.host, call_594512.base,
                         call_594512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594512, url, valid)

proc call*(call_594513: Call_RunProjectsLocationsAutodomainmappingsCreate_594496;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsAutodomainmappingsCreate
  ## Creates a new auto domain mapping.
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
  ##   parent: string (required)
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594514 = newJObject()
  var query_594515 = newJObject()
  var body_594516 = newJObject()
  add(query_594515, "upload_protocol", newJString(uploadProtocol))
  add(query_594515, "fields", newJString(fields))
  add(query_594515, "quotaUser", newJString(quotaUser))
  add(query_594515, "alt", newJString(alt))
  add(query_594515, "oauth_token", newJString(oauthToken))
  add(query_594515, "callback", newJString(callback))
  add(query_594515, "access_token", newJString(accessToken))
  add(query_594515, "uploadType", newJString(uploadType))
  add(path_594514, "parent", newJString(parent))
  add(query_594515, "key", newJString(key))
  add(query_594515, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594516 = body
  add(query_594515, "prettyPrint", newJBool(prettyPrint))
  result = call_594513.call(path_594514, query_594515, nil, nil, body_594516)

var runProjectsLocationsAutodomainmappingsCreate* = Call_RunProjectsLocationsAutodomainmappingsCreate_594496(
    name: "runProjectsLocationsAutodomainmappingsCreate",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1/{parent}/autodomainmappings",
    validator: validate_RunProjectsLocationsAutodomainmappingsCreate_594497,
    base: "/", url: url_RunProjectsLocationsAutodomainmappingsCreate_594498,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAutodomainmappingsList_594470 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsAutodomainmappingsList_594472(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsAutodomainmappingsList_594471(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List auto domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594473 = path.getOrDefault("parent")
  valid_594473 = validateParameter(valid_594473, JString, required = true,
                                 default = nil)
  if valid_594473 != nil:
    section.add "parent", valid_594473
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594474 = query.getOrDefault("upload_protocol")
  valid_594474 = validateParameter(valid_594474, JString, required = false,
                                 default = nil)
  if valid_594474 != nil:
    section.add "upload_protocol", valid_594474
  var valid_594475 = query.getOrDefault("fields")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = nil)
  if valid_594475 != nil:
    section.add "fields", valid_594475
  var valid_594476 = query.getOrDefault("quotaUser")
  valid_594476 = validateParameter(valid_594476, JString, required = false,
                                 default = nil)
  if valid_594476 != nil:
    section.add "quotaUser", valid_594476
  var valid_594477 = query.getOrDefault("includeUninitialized")
  valid_594477 = validateParameter(valid_594477, JBool, required = false, default = nil)
  if valid_594477 != nil:
    section.add "includeUninitialized", valid_594477
  var valid_594478 = query.getOrDefault("alt")
  valid_594478 = validateParameter(valid_594478, JString, required = false,
                                 default = newJString("json"))
  if valid_594478 != nil:
    section.add "alt", valid_594478
  var valid_594479 = query.getOrDefault("continue")
  valid_594479 = validateParameter(valid_594479, JString, required = false,
                                 default = nil)
  if valid_594479 != nil:
    section.add "continue", valid_594479
  var valid_594480 = query.getOrDefault("oauth_token")
  valid_594480 = validateParameter(valid_594480, JString, required = false,
                                 default = nil)
  if valid_594480 != nil:
    section.add "oauth_token", valid_594480
  var valid_594481 = query.getOrDefault("callback")
  valid_594481 = validateParameter(valid_594481, JString, required = false,
                                 default = nil)
  if valid_594481 != nil:
    section.add "callback", valid_594481
  var valid_594482 = query.getOrDefault("access_token")
  valid_594482 = validateParameter(valid_594482, JString, required = false,
                                 default = nil)
  if valid_594482 != nil:
    section.add "access_token", valid_594482
  var valid_594483 = query.getOrDefault("uploadType")
  valid_594483 = validateParameter(valid_594483, JString, required = false,
                                 default = nil)
  if valid_594483 != nil:
    section.add "uploadType", valid_594483
  var valid_594484 = query.getOrDefault("resourceVersion")
  valid_594484 = validateParameter(valid_594484, JString, required = false,
                                 default = nil)
  if valid_594484 != nil:
    section.add "resourceVersion", valid_594484
  var valid_594485 = query.getOrDefault("watch")
  valid_594485 = validateParameter(valid_594485, JBool, required = false, default = nil)
  if valid_594485 != nil:
    section.add "watch", valid_594485
  var valid_594486 = query.getOrDefault("key")
  valid_594486 = validateParameter(valid_594486, JString, required = false,
                                 default = nil)
  if valid_594486 != nil:
    section.add "key", valid_594486
  var valid_594487 = query.getOrDefault("$.xgafv")
  valid_594487 = validateParameter(valid_594487, JString, required = false,
                                 default = newJString("1"))
  if valid_594487 != nil:
    section.add "$.xgafv", valid_594487
  var valid_594488 = query.getOrDefault("labelSelector")
  valid_594488 = validateParameter(valid_594488, JString, required = false,
                                 default = nil)
  if valid_594488 != nil:
    section.add "labelSelector", valid_594488
  var valid_594489 = query.getOrDefault("prettyPrint")
  valid_594489 = validateParameter(valid_594489, JBool, required = false,
                                 default = newJBool(true))
  if valid_594489 != nil:
    section.add "prettyPrint", valid_594489
  var valid_594490 = query.getOrDefault("fieldSelector")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "fieldSelector", valid_594490
  var valid_594491 = query.getOrDefault("limit")
  valid_594491 = validateParameter(valid_594491, JInt, required = false, default = nil)
  if valid_594491 != nil:
    section.add "limit", valid_594491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594492: Call_RunProjectsLocationsAutodomainmappingsList_594470;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List auto domain mappings.
  ## 
  let valid = call_594492.validator(path, query, header, formData, body)
  let scheme = call_594492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594492.url(scheme.get, call_594492.host, call_594492.base,
                         call_594492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594492, url, valid)

proc call*(call_594493: Call_RunProjectsLocationsAutodomainmappingsList_594470;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsAutodomainmappingsList
  ## List auto domain mappings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594494 = newJObject()
  var query_594495 = newJObject()
  add(query_594495, "upload_protocol", newJString(uploadProtocol))
  add(query_594495, "fields", newJString(fields))
  add(query_594495, "quotaUser", newJString(quotaUser))
  add(query_594495, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594495, "alt", newJString(alt))
  add(query_594495, "continue", newJString(`continue`))
  add(query_594495, "oauth_token", newJString(oauthToken))
  add(query_594495, "callback", newJString(callback))
  add(query_594495, "access_token", newJString(accessToken))
  add(query_594495, "uploadType", newJString(uploadType))
  add(path_594494, "parent", newJString(parent))
  add(query_594495, "resourceVersion", newJString(resourceVersion))
  add(query_594495, "watch", newJBool(watch))
  add(query_594495, "key", newJString(key))
  add(query_594495, "$.xgafv", newJString(Xgafv))
  add(query_594495, "labelSelector", newJString(labelSelector))
  add(query_594495, "prettyPrint", newJBool(prettyPrint))
  add(query_594495, "fieldSelector", newJString(fieldSelector))
  add(query_594495, "limit", newJInt(limit))
  result = call_594493.call(path_594494, query_594495, nil, nil, nil)

var runProjectsLocationsAutodomainmappingsList* = Call_RunProjectsLocationsAutodomainmappingsList_594470(
    name: "runProjectsLocationsAutodomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/autodomainmappings",
    validator: validate_RunProjectsLocationsAutodomainmappingsList_594471,
    base: "/", url: url_RunProjectsLocationsAutodomainmappingsList_594472,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsCreate_594543 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsConfigurationsCreate_594545(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsConfigurationsCreate_594544(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this configuration should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594546 = path.getOrDefault("parent")
  valid_594546 = validateParameter(valid_594546, JString, required = true,
                                 default = nil)
  if valid_594546 != nil:
    section.add "parent", valid_594546
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
  var valid_594547 = query.getOrDefault("upload_protocol")
  valid_594547 = validateParameter(valid_594547, JString, required = false,
                                 default = nil)
  if valid_594547 != nil:
    section.add "upload_protocol", valid_594547
  var valid_594548 = query.getOrDefault("fields")
  valid_594548 = validateParameter(valid_594548, JString, required = false,
                                 default = nil)
  if valid_594548 != nil:
    section.add "fields", valid_594548
  var valid_594549 = query.getOrDefault("quotaUser")
  valid_594549 = validateParameter(valid_594549, JString, required = false,
                                 default = nil)
  if valid_594549 != nil:
    section.add "quotaUser", valid_594549
  var valid_594550 = query.getOrDefault("alt")
  valid_594550 = validateParameter(valid_594550, JString, required = false,
                                 default = newJString("json"))
  if valid_594550 != nil:
    section.add "alt", valid_594550
  var valid_594551 = query.getOrDefault("oauth_token")
  valid_594551 = validateParameter(valid_594551, JString, required = false,
                                 default = nil)
  if valid_594551 != nil:
    section.add "oauth_token", valid_594551
  var valid_594552 = query.getOrDefault("callback")
  valid_594552 = validateParameter(valid_594552, JString, required = false,
                                 default = nil)
  if valid_594552 != nil:
    section.add "callback", valid_594552
  var valid_594553 = query.getOrDefault("access_token")
  valid_594553 = validateParameter(valid_594553, JString, required = false,
                                 default = nil)
  if valid_594553 != nil:
    section.add "access_token", valid_594553
  var valid_594554 = query.getOrDefault("uploadType")
  valid_594554 = validateParameter(valid_594554, JString, required = false,
                                 default = nil)
  if valid_594554 != nil:
    section.add "uploadType", valid_594554
  var valid_594555 = query.getOrDefault("key")
  valid_594555 = validateParameter(valid_594555, JString, required = false,
                                 default = nil)
  if valid_594555 != nil:
    section.add "key", valid_594555
  var valid_594556 = query.getOrDefault("$.xgafv")
  valid_594556 = validateParameter(valid_594556, JString, required = false,
                                 default = newJString("1"))
  if valid_594556 != nil:
    section.add "$.xgafv", valid_594556
  var valid_594557 = query.getOrDefault("prettyPrint")
  valid_594557 = validateParameter(valid_594557, JBool, required = false,
                                 default = newJBool(true))
  if valid_594557 != nil:
    section.add "prettyPrint", valid_594557
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

proc call*(call_594559: Call_RunProjectsLocationsConfigurationsCreate_594543;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a configuration.
  ## 
  let valid = call_594559.validator(path, query, header, formData, body)
  let scheme = call_594559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594559.url(scheme.get, call_594559.host, call_594559.base,
                         call_594559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594559, url, valid)

proc call*(call_594560: Call_RunProjectsLocationsConfigurationsCreate_594543;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsConfigurationsCreate
  ## Create a configuration.
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
  ##   parent: string (required)
  ##         : The project ID or project number in which this configuration should be
  ## created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594561 = newJObject()
  var query_594562 = newJObject()
  var body_594563 = newJObject()
  add(query_594562, "upload_protocol", newJString(uploadProtocol))
  add(query_594562, "fields", newJString(fields))
  add(query_594562, "quotaUser", newJString(quotaUser))
  add(query_594562, "alt", newJString(alt))
  add(query_594562, "oauth_token", newJString(oauthToken))
  add(query_594562, "callback", newJString(callback))
  add(query_594562, "access_token", newJString(accessToken))
  add(query_594562, "uploadType", newJString(uploadType))
  add(path_594561, "parent", newJString(parent))
  add(query_594562, "key", newJString(key))
  add(query_594562, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594563 = body
  add(query_594562, "prettyPrint", newJBool(prettyPrint))
  result = call_594560.call(path_594561, query_594562, nil, nil, body_594563)

var runProjectsLocationsConfigurationsCreate* = Call_RunProjectsLocationsConfigurationsCreate_594543(
    name: "runProjectsLocationsConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsCreate_594544,
    base: "/", url: url_RunProjectsLocationsConfigurationsCreate_594545,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsList_594517 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsConfigurationsList_594519(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsConfigurationsList_594518(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594520 = path.getOrDefault("parent")
  valid_594520 = validateParameter(valid_594520, JString, required = true,
                                 default = nil)
  if valid_594520 != nil:
    section.add "parent", valid_594520
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594521 = query.getOrDefault("upload_protocol")
  valid_594521 = validateParameter(valid_594521, JString, required = false,
                                 default = nil)
  if valid_594521 != nil:
    section.add "upload_protocol", valid_594521
  var valid_594522 = query.getOrDefault("fields")
  valid_594522 = validateParameter(valid_594522, JString, required = false,
                                 default = nil)
  if valid_594522 != nil:
    section.add "fields", valid_594522
  var valid_594523 = query.getOrDefault("quotaUser")
  valid_594523 = validateParameter(valid_594523, JString, required = false,
                                 default = nil)
  if valid_594523 != nil:
    section.add "quotaUser", valid_594523
  var valid_594524 = query.getOrDefault("includeUninitialized")
  valid_594524 = validateParameter(valid_594524, JBool, required = false, default = nil)
  if valid_594524 != nil:
    section.add "includeUninitialized", valid_594524
  var valid_594525 = query.getOrDefault("alt")
  valid_594525 = validateParameter(valid_594525, JString, required = false,
                                 default = newJString("json"))
  if valid_594525 != nil:
    section.add "alt", valid_594525
  var valid_594526 = query.getOrDefault("continue")
  valid_594526 = validateParameter(valid_594526, JString, required = false,
                                 default = nil)
  if valid_594526 != nil:
    section.add "continue", valid_594526
  var valid_594527 = query.getOrDefault("oauth_token")
  valid_594527 = validateParameter(valid_594527, JString, required = false,
                                 default = nil)
  if valid_594527 != nil:
    section.add "oauth_token", valid_594527
  var valid_594528 = query.getOrDefault("callback")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = nil)
  if valid_594528 != nil:
    section.add "callback", valid_594528
  var valid_594529 = query.getOrDefault("access_token")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = nil)
  if valid_594529 != nil:
    section.add "access_token", valid_594529
  var valid_594530 = query.getOrDefault("uploadType")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = nil)
  if valid_594530 != nil:
    section.add "uploadType", valid_594530
  var valid_594531 = query.getOrDefault("resourceVersion")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = nil)
  if valid_594531 != nil:
    section.add "resourceVersion", valid_594531
  var valid_594532 = query.getOrDefault("watch")
  valid_594532 = validateParameter(valid_594532, JBool, required = false, default = nil)
  if valid_594532 != nil:
    section.add "watch", valid_594532
  var valid_594533 = query.getOrDefault("key")
  valid_594533 = validateParameter(valid_594533, JString, required = false,
                                 default = nil)
  if valid_594533 != nil:
    section.add "key", valid_594533
  var valid_594534 = query.getOrDefault("$.xgafv")
  valid_594534 = validateParameter(valid_594534, JString, required = false,
                                 default = newJString("1"))
  if valid_594534 != nil:
    section.add "$.xgafv", valid_594534
  var valid_594535 = query.getOrDefault("labelSelector")
  valid_594535 = validateParameter(valid_594535, JString, required = false,
                                 default = nil)
  if valid_594535 != nil:
    section.add "labelSelector", valid_594535
  var valid_594536 = query.getOrDefault("prettyPrint")
  valid_594536 = validateParameter(valid_594536, JBool, required = false,
                                 default = newJBool(true))
  if valid_594536 != nil:
    section.add "prettyPrint", valid_594536
  var valid_594537 = query.getOrDefault("fieldSelector")
  valid_594537 = validateParameter(valid_594537, JString, required = false,
                                 default = nil)
  if valid_594537 != nil:
    section.add "fieldSelector", valid_594537
  var valid_594538 = query.getOrDefault("limit")
  valid_594538 = validateParameter(valid_594538, JInt, required = false, default = nil)
  if valid_594538 != nil:
    section.add "limit", valid_594538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594539: Call_RunProjectsLocationsConfigurationsList_594517;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurations.
  ## 
  let valid = call_594539.validator(path, query, header, formData, body)
  let scheme = call_594539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594539.url(scheme.get, call_594539.host, call_594539.base,
                         call_594539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594539, url, valid)

proc call*(call_594540: Call_RunProjectsLocationsConfigurationsList_594517;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsConfigurationsList
  ## List configurations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594541 = newJObject()
  var query_594542 = newJObject()
  add(query_594542, "upload_protocol", newJString(uploadProtocol))
  add(query_594542, "fields", newJString(fields))
  add(query_594542, "quotaUser", newJString(quotaUser))
  add(query_594542, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594542, "alt", newJString(alt))
  add(query_594542, "continue", newJString(`continue`))
  add(query_594542, "oauth_token", newJString(oauthToken))
  add(query_594542, "callback", newJString(callback))
  add(query_594542, "access_token", newJString(accessToken))
  add(query_594542, "uploadType", newJString(uploadType))
  add(path_594541, "parent", newJString(parent))
  add(query_594542, "resourceVersion", newJString(resourceVersion))
  add(query_594542, "watch", newJBool(watch))
  add(query_594542, "key", newJString(key))
  add(query_594542, "$.xgafv", newJString(Xgafv))
  add(query_594542, "labelSelector", newJString(labelSelector))
  add(query_594542, "prettyPrint", newJBool(prettyPrint))
  add(query_594542, "fieldSelector", newJString(fieldSelector))
  add(query_594542, "limit", newJInt(limit))
  result = call_594540.call(path_594541, query_594542, nil, nil, nil)

var runProjectsLocationsConfigurationsList* = Call_RunProjectsLocationsConfigurationsList_594517(
    name: "runProjectsLocationsConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsList_594518, base: "/",
    url: url_RunProjectsLocationsConfigurationsList_594519,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsCreate_594590 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsDomainmappingsCreate_594592(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsCreate_594591(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594593 = path.getOrDefault("parent")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "parent", valid_594593
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
  var valid_594594 = query.getOrDefault("upload_protocol")
  valid_594594 = validateParameter(valid_594594, JString, required = false,
                                 default = nil)
  if valid_594594 != nil:
    section.add "upload_protocol", valid_594594
  var valid_594595 = query.getOrDefault("fields")
  valid_594595 = validateParameter(valid_594595, JString, required = false,
                                 default = nil)
  if valid_594595 != nil:
    section.add "fields", valid_594595
  var valid_594596 = query.getOrDefault("quotaUser")
  valid_594596 = validateParameter(valid_594596, JString, required = false,
                                 default = nil)
  if valid_594596 != nil:
    section.add "quotaUser", valid_594596
  var valid_594597 = query.getOrDefault("alt")
  valid_594597 = validateParameter(valid_594597, JString, required = false,
                                 default = newJString("json"))
  if valid_594597 != nil:
    section.add "alt", valid_594597
  var valid_594598 = query.getOrDefault("oauth_token")
  valid_594598 = validateParameter(valid_594598, JString, required = false,
                                 default = nil)
  if valid_594598 != nil:
    section.add "oauth_token", valid_594598
  var valid_594599 = query.getOrDefault("callback")
  valid_594599 = validateParameter(valid_594599, JString, required = false,
                                 default = nil)
  if valid_594599 != nil:
    section.add "callback", valid_594599
  var valid_594600 = query.getOrDefault("access_token")
  valid_594600 = validateParameter(valid_594600, JString, required = false,
                                 default = nil)
  if valid_594600 != nil:
    section.add "access_token", valid_594600
  var valid_594601 = query.getOrDefault("uploadType")
  valid_594601 = validateParameter(valid_594601, JString, required = false,
                                 default = nil)
  if valid_594601 != nil:
    section.add "uploadType", valid_594601
  var valid_594602 = query.getOrDefault("key")
  valid_594602 = validateParameter(valid_594602, JString, required = false,
                                 default = nil)
  if valid_594602 != nil:
    section.add "key", valid_594602
  var valid_594603 = query.getOrDefault("$.xgafv")
  valid_594603 = validateParameter(valid_594603, JString, required = false,
                                 default = newJString("1"))
  if valid_594603 != nil:
    section.add "$.xgafv", valid_594603
  var valid_594604 = query.getOrDefault("prettyPrint")
  valid_594604 = validateParameter(valid_594604, JBool, required = false,
                                 default = newJBool(true))
  if valid_594604 != nil:
    section.add "prettyPrint", valid_594604
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

proc call*(call_594606: Call_RunProjectsLocationsDomainmappingsCreate_594590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new domain mapping.
  ## 
  let valid = call_594606.validator(path, query, header, formData, body)
  let scheme = call_594606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594606.url(scheme.get, call_594606.host, call_594606.base,
                         call_594606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594606, url, valid)

proc call*(call_594607: Call_RunProjectsLocationsDomainmappingsCreate_594590;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsDomainmappingsCreate
  ## Create a new domain mapping.
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
  ##   parent: string (required)
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594608 = newJObject()
  var query_594609 = newJObject()
  var body_594610 = newJObject()
  add(query_594609, "upload_protocol", newJString(uploadProtocol))
  add(query_594609, "fields", newJString(fields))
  add(query_594609, "quotaUser", newJString(quotaUser))
  add(query_594609, "alt", newJString(alt))
  add(query_594609, "oauth_token", newJString(oauthToken))
  add(query_594609, "callback", newJString(callback))
  add(query_594609, "access_token", newJString(accessToken))
  add(query_594609, "uploadType", newJString(uploadType))
  add(path_594608, "parent", newJString(parent))
  add(query_594609, "key", newJString(key))
  add(query_594609, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594610 = body
  add(query_594609, "prettyPrint", newJBool(prettyPrint))
  result = call_594607.call(path_594608, query_594609, nil, nil, body_594610)

var runProjectsLocationsDomainmappingsCreate* = Call_RunProjectsLocationsDomainmappingsCreate_594590(
    name: "runProjectsLocationsDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsCreate_594591,
    base: "/", url: url_RunProjectsLocationsDomainmappingsCreate_594592,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsList_594564 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsDomainmappingsList_594566(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsList_594565(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594567 = path.getOrDefault("parent")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "parent", valid_594567
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594568 = query.getOrDefault("upload_protocol")
  valid_594568 = validateParameter(valid_594568, JString, required = false,
                                 default = nil)
  if valid_594568 != nil:
    section.add "upload_protocol", valid_594568
  var valid_594569 = query.getOrDefault("fields")
  valid_594569 = validateParameter(valid_594569, JString, required = false,
                                 default = nil)
  if valid_594569 != nil:
    section.add "fields", valid_594569
  var valid_594570 = query.getOrDefault("quotaUser")
  valid_594570 = validateParameter(valid_594570, JString, required = false,
                                 default = nil)
  if valid_594570 != nil:
    section.add "quotaUser", valid_594570
  var valid_594571 = query.getOrDefault("includeUninitialized")
  valid_594571 = validateParameter(valid_594571, JBool, required = false, default = nil)
  if valid_594571 != nil:
    section.add "includeUninitialized", valid_594571
  var valid_594572 = query.getOrDefault("alt")
  valid_594572 = validateParameter(valid_594572, JString, required = false,
                                 default = newJString("json"))
  if valid_594572 != nil:
    section.add "alt", valid_594572
  var valid_594573 = query.getOrDefault("continue")
  valid_594573 = validateParameter(valid_594573, JString, required = false,
                                 default = nil)
  if valid_594573 != nil:
    section.add "continue", valid_594573
  var valid_594574 = query.getOrDefault("oauth_token")
  valid_594574 = validateParameter(valid_594574, JString, required = false,
                                 default = nil)
  if valid_594574 != nil:
    section.add "oauth_token", valid_594574
  var valid_594575 = query.getOrDefault("callback")
  valid_594575 = validateParameter(valid_594575, JString, required = false,
                                 default = nil)
  if valid_594575 != nil:
    section.add "callback", valid_594575
  var valid_594576 = query.getOrDefault("access_token")
  valid_594576 = validateParameter(valid_594576, JString, required = false,
                                 default = nil)
  if valid_594576 != nil:
    section.add "access_token", valid_594576
  var valid_594577 = query.getOrDefault("uploadType")
  valid_594577 = validateParameter(valid_594577, JString, required = false,
                                 default = nil)
  if valid_594577 != nil:
    section.add "uploadType", valid_594577
  var valid_594578 = query.getOrDefault("resourceVersion")
  valid_594578 = validateParameter(valid_594578, JString, required = false,
                                 default = nil)
  if valid_594578 != nil:
    section.add "resourceVersion", valid_594578
  var valid_594579 = query.getOrDefault("watch")
  valid_594579 = validateParameter(valid_594579, JBool, required = false, default = nil)
  if valid_594579 != nil:
    section.add "watch", valid_594579
  var valid_594580 = query.getOrDefault("key")
  valid_594580 = validateParameter(valid_594580, JString, required = false,
                                 default = nil)
  if valid_594580 != nil:
    section.add "key", valid_594580
  var valid_594581 = query.getOrDefault("$.xgafv")
  valid_594581 = validateParameter(valid_594581, JString, required = false,
                                 default = newJString("1"))
  if valid_594581 != nil:
    section.add "$.xgafv", valid_594581
  var valid_594582 = query.getOrDefault("labelSelector")
  valid_594582 = validateParameter(valid_594582, JString, required = false,
                                 default = nil)
  if valid_594582 != nil:
    section.add "labelSelector", valid_594582
  var valid_594583 = query.getOrDefault("prettyPrint")
  valid_594583 = validateParameter(valid_594583, JBool, required = false,
                                 default = newJBool(true))
  if valid_594583 != nil:
    section.add "prettyPrint", valid_594583
  var valid_594584 = query.getOrDefault("fieldSelector")
  valid_594584 = validateParameter(valid_594584, JString, required = false,
                                 default = nil)
  if valid_594584 != nil:
    section.add "fieldSelector", valid_594584
  var valid_594585 = query.getOrDefault("limit")
  valid_594585 = validateParameter(valid_594585, JInt, required = false, default = nil)
  if valid_594585 != nil:
    section.add "limit", valid_594585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594586: Call_RunProjectsLocationsDomainmappingsList_594564;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List domain mappings.
  ## 
  let valid = call_594586.validator(path, query, header, formData, body)
  let scheme = call_594586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594586.url(scheme.get, call_594586.host, call_594586.base,
                         call_594586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594586, url, valid)

proc call*(call_594587: Call_RunProjectsLocationsDomainmappingsList_594564;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsDomainmappingsList
  ## List domain mappings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594588 = newJObject()
  var query_594589 = newJObject()
  add(query_594589, "upload_protocol", newJString(uploadProtocol))
  add(query_594589, "fields", newJString(fields))
  add(query_594589, "quotaUser", newJString(quotaUser))
  add(query_594589, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594589, "alt", newJString(alt))
  add(query_594589, "continue", newJString(`continue`))
  add(query_594589, "oauth_token", newJString(oauthToken))
  add(query_594589, "callback", newJString(callback))
  add(query_594589, "access_token", newJString(accessToken))
  add(query_594589, "uploadType", newJString(uploadType))
  add(path_594588, "parent", newJString(parent))
  add(query_594589, "resourceVersion", newJString(resourceVersion))
  add(query_594589, "watch", newJBool(watch))
  add(query_594589, "key", newJString(key))
  add(query_594589, "$.xgafv", newJString(Xgafv))
  add(query_594589, "labelSelector", newJString(labelSelector))
  add(query_594589, "prettyPrint", newJBool(prettyPrint))
  add(query_594589, "fieldSelector", newJString(fieldSelector))
  add(query_594589, "limit", newJInt(limit))
  result = call_594587.call(path_594588, query_594589, nil, nil, nil)

var runProjectsLocationsDomainmappingsList* = Call_RunProjectsLocationsDomainmappingsList_594564(
    name: "runProjectsLocationsDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsList_594565, base: "/",
    url: url_RunProjectsLocationsDomainmappingsList_594566,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRevisionsList_594611 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsRevisionsList_594613(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsRevisionsList_594612(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the revisions should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594614 = path.getOrDefault("parent")
  valid_594614 = validateParameter(valid_594614, JString, required = true,
                                 default = nil)
  if valid_594614 != nil:
    section.add "parent", valid_594614
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594615 = query.getOrDefault("upload_protocol")
  valid_594615 = validateParameter(valid_594615, JString, required = false,
                                 default = nil)
  if valid_594615 != nil:
    section.add "upload_protocol", valid_594615
  var valid_594616 = query.getOrDefault("fields")
  valid_594616 = validateParameter(valid_594616, JString, required = false,
                                 default = nil)
  if valid_594616 != nil:
    section.add "fields", valid_594616
  var valid_594617 = query.getOrDefault("quotaUser")
  valid_594617 = validateParameter(valid_594617, JString, required = false,
                                 default = nil)
  if valid_594617 != nil:
    section.add "quotaUser", valid_594617
  var valid_594618 = query.getOrDefault("includeUninitialized")
  valid_594618 = validateParameter(valid_594618, JBool, required = false, default = nil)
  if valid_594618 != nil:
    section.add "includeUninitialized", valid_594618
  var valid_594619 = query.getOrDefault("alt")
  valid_594619 = validateParameter(valid_594619, JString, required = false,
                                 default = newJString("json"))
  if valid_594619 != nil:
    section.add "alt", valid_594619
  var valid_594620 = query.getOrDefault("continue")
  valid_594620 = validateParameter(valid_594620, JString, required = false,
                                 default = nil)
  if valid_594620 != nil:
    section.add "continue", valid_594620
  var valid_594621 = query.getOrDefault("oauth_token")
  valid_594621 = validateParameter(valid_594621, JString, required = false,
                                 default = nil)
  if valid_594621 != nil:
    section.add "oauth_token", valid_594621
  var valid_594622 = query.getOrDefault("callback")
  valid_594622 = validateParameter(valid_594622, JString, required = false,
                                 default = nil)
  if valid_594622 != nil:
    section.add "callback", valid_594622
  var valid_594623 = query.getOrDefault("access_token")
  valid_594623 = validateParameter(valid_594623, JString, required = false,
                                 default = nil)
  if valid_594623 != nil:
    section.add "access_token", valid_594623
  var valid_594624 = query.getOrDefault("uploadType")
  valid_594624 = validateParameter(valid_594624, JString, required = false,
                                 default = nil)
  if valid_594624 != nil:
    section.add "uploadType", valid_594624
  var valid_594625 = query.getOrDefault("resourceVersion")
  valid_594625 = validateParameter(valid_594625, JString, required = false,
                                 default = nil)
  if valid_594625 != nil:
    section.add "resourceVersion", valid_594625
  var valid_594626 = query.getOrDefault("watch")
  valid_594626 = validateParameter(valid_594626, JBool, required = false, default = nil)
  if valid_594626 != nil:
    section.add "watch", valid_594626
  var valid_594627 = query.getOrDefault("key")
  valid_594627 = validateParameter(valid_594627, JString, required = false,
                                 default = nil)
  if valid_594627 != nil:
    section.add "key", valid_594627
  var valid_594628 = query.getOrDefault("$.xgafv")
  valid_594628 = validateParameter(valid_594628, JString, required = false,
                                 default = newJString("1"))
  if valid_594628 != nil:
    section.add "$.xgafv", valid_594628
  var valid_594629 = query.getOrDefault("labelSelector")
  valid_594629 = validateParameter(valid_594629, JString, required = false,
                                 default = nil)
  if valid_594629 != nil:
    section.add "labelSelector", valid_594629
  var valid_594630 = query.getOrDefault("prettyPrint")
  valid_594630 = validateParameter(valid_594630, JBool, required = false,
                                 default = newJBool(true))
  if valid_594630 != nil:
    section.add "prettyPrint", valid_594630
  var valid_594631 = query.getOrDefault("fieldSelector")
  valid_594631 = validateParameter(valid_594631, JString, required = false,
                                 default = nil)
  if valid_594631 != nil:
    section.add "fieldSelector", valid_594631
  var valid_594632 = query.getOrDefault("limit")
  valid_594632 = validateParameter(valid_594632, JInt, required = false, default = nil)
  if valid_594632 != nil:
    section.add "limit", valid_594632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594633: Call_RunProjectsLocationsRevisionsList_594611;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List revisions.
  ## 
  let valid = call_594633.validator(path, query, header, formData, body)
  let scheme = call_594633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594633.url(scheme.get, call_594633.host, call_594633.base,
                         call_594633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594633, url, valid)

proc call*(call_594634: Call_RunProjectsLocationsRevisionsList_594611;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsRevisionsList
  ## List revisions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the revisions should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594635 = newJObject()
  var query_594636 = newJObject()
  add(query_594636, "upload_protocol", newJString(uploadProtocol))
  add(query_594636, "fields", newJString(fields))
  add(query_594636, "quotaUser", newJString(quotaUser))
  add(query_594636, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594636, "alt", newJString(alt))
  add(query_594636, "continue", newJString(`continue`))
  add(query_594636, "oauth_token", newJString(oauthToken))
  add(query_594636, "callback", newJString(callback))
  add(query_594636, "access_token", newJString(accessToken))
  add(query_594636, "uploadType", newJString(uploadType))
  add(path_594635, "parent", newJString(parent))
  add(query_594636, "resourceVersion", newJString(resourceVersion))
  add(query_594636, "watch", newJBool(watch))
  add(query_594636, "key", newJString(key))
  add(query_594636, "$.xgafv", newJString(Xgafv))
  add(query_594636, "labelSelector", newJString(labelSelector))
  add(query_594636, "prettyPrint", newJBool(prettyPrint))
  add(query_594636, "fieldSelector", newJString(fieldSelector))
  add(query_594636, "limit", newJInt(limit))
  result = call_594634.call(path_594635, query_594636, nil, nil, nil)

var runProjectsLocationsRevisionsList* = Call_RunProjectsLocationsRevisionsList_594611(
    name: "runProjectsLocationsRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/revisions",
    validator: validate_RunProjectsLocationsRevisionsList_594612, base: "/",
    url: url_RunProjectsLocationsRevisionsList_594613, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesCreate_594663 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsRoutesCreate_594665(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsRoutesCreate_594664(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a route.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this route should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594666 = path.getOrDefault("parent")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = nil)
  if valid_594666 != nil:
    section.add "parent", valid_594666
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
  var valid_594667 = query.getOrDefault("upload_protocol")
  valid_594667 = validateParameter(valid_594667, JString, required = false,
                                 default = nil)
  if valid_594667 != nil:
    section.add "upload_protocol", valid_594667
  var valid_594668 = query.getOrDefault("fields")
  valid_594668 = validateParameter(valid_594668, JString, required = false,
                                 default = nil)
  if valid_594668 != nil:
    section.add "fields", valid_594668
  var valid_594669 = query.getOrDefault("quotaUser")
  valid_594669 = validateParameter(valid_594669, JString, required = false,
                                 default = nil)
  if valid_594669 != nil:
    section.add "quotaUser", valid_594669
  var valid_594670 = query.getOrDefault("alt")
  valid_594670 = validateParameter(valid_594670, JString, required = false,
                                 default = newJString("json"))
  if valid_594670 != nil:
    section.add "alt", valid_594670
  var valid_594671 = query.getOrDefault("oauth_token")
  valid_594671 = validateParameter(valid_594671, JString, required = false,
                                 default = nil)
  if valid_594671 != nil:
    section.add "oauth_token", valid_594671
  var valid_594672 = query.getOrDefault("callback")
  valid_594672 = validateParameter(valid_594672, JString, required = false,
                                 default = nil)
  if valid_594672 != nil:
    section.add "callback", valid_594672
  var valid_594673 = query.getOrDefault("access_token")
  valid_594673 = validateParameter(valid_594673, JString, required = false,
                                 default = nil)
  if valid_594673 != nil:
    section.add "access_token", valid_594673
  var valid_594674 = query.getOrDefault("uploadType")
  valid_594674 = validateParameter(valid_594674, JString, required = false,
                                 default = nil)
  if valid_594674 != nil:
    section.add "uploadType", valid_594674
  var valid_594675 = query.getOrDefault("key")
  valid_594675 = validateParameter(valid_594675, JString, required = false,
                                 default = nil)
  if valid_594675 != nil:
    section.add "key", valid_594675
  var valid_594676 = query.getOrDefault("$.xgafv")
  valid_594676 = validateParameter(valid_594676, JString, required = false,
                                 default = newJString("1"))
  if valid_594676 != nil:
    section.add "$.xgafv", valid_594676
  var valid_594677 = query.getOrDefault("prettyPrint")
  valid_594677 = validateParameter(valid_594677, JBool, required = false,
                                 default = newJBool(true))
  if valid_594677 != nil:
    section.add "prettyPrint", valid_594677
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

proc call*(call_594679: Call_RunProjectsLocationsRoutesCreate_594663;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a route.
  ## 
  let valid = call_594679.validator(path, query, header, formData, body)
  let scheme = call_594679.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594679.url(scheme.get, call_594679.host, call_594679.base,
                         call_594679.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594679, url, valid)

proc call*(call_594680: Call_RunProjectsLocationsRoutesCreate_594663;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsRoutesCreate
  ## Create a route.
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
  ##   parent: string (required)
  ##         : The project ID or project number in which this route should be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594681 = newJObject()
  var query_594682 = newJObject()
  var body_594683 = newJObject()
  add(query_594682, "upload_protocol", newJString(uploadProtocol))
  add(query_594682, "fields", newJString(fields))
  add(query_594682, "quotaUser", newJString(quotaUser))
  add(query_594682, "alt", newJString(alt))
  add(query_594682, "oauth_token", newJString(oauthToken))
  add(query_594682, "callback", newJString(callback))
  add(query_594682, "access_token", newJString(accessToken))
  add(query_594682, "uploadType", newJString(uploadType))
  add(path_594681, "parent", newJString(parent))
  add(query_594682, "key", newJString(key))
  add(query_594682, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594683 = body
  add(query_594682, "prettyPrint", newJBool(prettyPrint))
  result = call_594680.call(path_594681, query_594682, nil, nil, body_594683)

var runProjectsLocationsRoutesCreate* = Call_RunProjectsLocationsRoutesCreate_594663(
    name: "runProjectsLocationsRoutesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesCreate_594664, base: "/",
    url: url_RunProjectsLocationsRoutesCreate_594665, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesList_594637 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsRoutesList_594639(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsRoutesList_594638(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List routes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the routes should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594640 = path.getOrDefault("parent")
  valid_594640 = validateParameter(valid_594640, JString, required = true,
                                 default = nil)
  if valid_594640 != nil:
    section.add "parent", valid_594640
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594641 = query.getOrDefault("upload_protocol")
  valid_594641 = validateParameter(valid_594641, JString, required = false,
                                 default = nil)
  if valid_594641 != nil:
    section.add "upload_protocol", valid_594641
  var valid_594642 = query.getOrDefault("fields")
  valid_594642 = validateParameter(valid_594642, JString, required = false,
                                 default = nil)
  if valid_594642 != nil:
    section.add "fields", valid_594642
  var valid_594643 = query.getOrDefault("quotaUser")
  valid_594643 = validateParameter(valid_594643, JString, required = false,
                                 default = nil)
  if valid_594643 != nil:
    section.add "quotaUser", valid_594643
  var valid_594644 = query.getOrDefault("includeUninitialized")
  valid_594644 = validateParameter(valid_594644, JBool, required = false, default = nil)
  if valid_594644 != nil:
    section.add "includeUninitialized", valid_594644
  var valid_594645 = query.getOrDefault("alt")
  valid_594645 = validateParameter(valid_594645, JString, required = false,
                                 default = newJString("json"))
  if valid_594645 != nil:
    section.add "alt", valid_594645
  var valid_594646 = query.getOrDefault("continue")
  valid_594646 = validateParameter(valid_594646, JString, required = false,
                                 default = nil)
  if valid_594646 != nil:
    section.add "continue", valid_594646
  var valid_594647 = query.getOrDefault("oauth_token")
  valid_594647 = validateParameter(valid_594647, JString, required = false,
                                 default = nil)
  if valid_594647 != nil:
    section.add "oauth_token", valid_594647
  var valid_594648 = query.getOrDefault("callback")
  valid_594648 = validateParameter(valid_594648, JString, required = false,
                                 default = nil)
  if valid_594648 != nil:
    section.add "callback", valid_594648
  var valid_594649 = query.getOrDefault("access_token")
  valid_594649 = validateParameter(valid_594649, JString, required = false,
                                 default = nil)
  if valid_594649 != nil:
    section.add "access_token", valid_594649
  var valid_594650 = query.getOrDefault("uploadType")
  valid_594650 = validateParameter(valid_594650, JString, required = false,
                                 default = nil)
  if valid_594650 != nil:
    section.add "uploadType", valid_594650
  var valid_594651 = query.getOrDefault("resourceVersion")
  valid_594651 = validateParameter(valid_594651, JString, required = false,
                                 default = nil)
  if valid_594651 != nil:
    section.add "resourceVersion", valid_594651
  var valid_594652 = query.getOrDefault("watch")
  valid_594652 = validateParameter(valid_594652, JBool, required = false, default = nil)
  if valid_594652 != nil:
    section.add "watch", valid_594652
  var valid_594653 = query.getOrDefault("key")
  valid_594653 = validateParameter(valid_594653, JString, required = false,
                                 default = nil)
  if valid_594653 != nil:
    section.add "key", valid_594653
  var valid_594654 = query.getOrDefault("$.xgafv")
  valid_594654 = validateParameter(valid_594654, JString, required = false,
                                 default = newJString("1"))
  if valid_594654 != nil:
    section.add "$.xgafv", valid_594654
  var valid_594655 = query.getOrDefault("labelSelector")
  valid_594655 = validateParameter(valid_594655, JString, required = false,
                                 default = nil)
  if valid_594655 != nil:
    section.add "labelSelector", valid_594655
  var valid_594656 = query.getOrDefault("prettyPrint")
  valid_594656 = validateParameter(valid_594656, JBool, required = false,
                                 default = newJBool(true))
  if valid_594656 != nil:
    section.add "prettyPrint", valid_594656
  var valid_594657 = query.getOrDefault("fieldSelector")
  valid_594657 = validateParameter(valid_594657, JString, required = false,
                                 default = nil)
  if valid_594657 != nil:
    section.add "fieldSelector", valid_594657
  var valid_594658 = query.getOrDefault("limit")
  valid_594658 = validateParameter(valid_594658, JInt, required = false, default = nil)
  if valid_594658 != nil:
    section.add "limit", valid_594658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594659: Call_RunProjectsLocationsRoutesList_594637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List routes.
  ## 
  let valid = call_594659.validator(path, query, header, formData, body)
  let scheme = call_594659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594659.url(scheme.get, call_594659.host, call_594659.base,
                         call_594659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594659, url, valid)

proc call*(call_594660: Call_RunProjectsLocationsRoutesList_594637; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsRoutesList
  ## List routes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the routes should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594661 = newJObject()
  var query_594662 = newJObject()
  add(query_594662, "upload_protocol", newJString(uploadProtocol))
  add(query_594662, "fields", newJString(fields))
  add(query_594662, "quotaUser", newJString(quotaUser))
  add(query_594662, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594662, "alt", newJString(alt))
  add(query_594662, "continue", newJString(`continue`))
  add(query_594662, "oauth_token", newJString(oauthToken))
  add(query_594662, "callback", newJString(callback))
  add(query_594662, "access_token", newJString(accessToken))
  add(query_594662, "uploadType", newJString(uploadType))
  add(path_594661, "parent", newJString(parent))
  add(query_594662, "resourceVersion", newJString(resourceVersion))
  add(query_594662, "watch", newJBool(watch))
  add(query_594662, "key", newJString(key))
  add(query_594662, "$.xgafv", newJString(Xgafv))
  add(query_594662, "labelSelector", newJString(labelSelector))
  add(query_594662, "prettyPrint", newJBool(prettyPrint))
  add(query_594662, "fieldSelector", newJString(fieldSelector))
  add(query_594662, "limit", newJInt(limit))
  result = call_594660.call(path_594661, query_594662, nil, nil, nil)

var runProjectsLocationsRoutesList* = Call_RunProjectsLocationsRoutesList_594637(
    name: "runProjectsLocationsRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesList_594638, base: "/",
    url: url_RunProjectsLocationsRoutesList_594639, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesCreate_594710 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsServicesCreate_594712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesCreate_594711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this service should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594713 = path.getOrDefault("parent")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "parent", valid_594713
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
  var valid_594714 = query.getOrDefault("upload_protocol")
  valid_594714 = validateParameter(valid_594714, JString, required = false,
                                 default = nil)
  if valid_594714 != nil:
    section.add "upload_protocol", valid_594714
  var valid_594715 = query.getOrDefault("fields")
  valid_594715 = validateParameter(valid_594715, JString, required = false,
                                 default = nil)
  if valid_594715 != nil:
    section.add "fields", valid_594715
  var valid_594716 = query.getOrDefault("quotaUser")
  valid_594716 = validateParameter(valid_594716, JString, required = false,
                                 default = nil)
  if valid_594716 != nil:
    section.add "quotaUser", valid_594716
  var valid_594717 = query.getOrDefault("alt")
  valid_594717 = validateParameter(valid_594717, JString, required = false,
                                 default = newJString("json"))
  if valid_594717 != nil:
    section.add "alt", valid_594717
  var valid_594718 = query.getOrDefault("oauth_token")
  valid_594718 = validateParameter(valid_594718, JString, required = false,
                                 default = nil)
  if valid_594718 != nil:
    section.add "oauth_token", valid_594718
  var valid_594719 = query.getOrDefault("callback")
  valid_594719 = validateParameter(valid_594719, JString, required = false,
                                 default = nil)
  if valid_594719 != nil:
    section.add "callback", valid_594719
  var valid_594720 = query.getOrDefault("access_token")
  valid_594720 = validateParameter(valid_594720, JString, required = false,
                                 default = nil)
  if valid_594720 != nil:
    section.add "access_token", valid_594720
  var valid_594721 = query.getOrDefault("uploadType")
  valid_594721 = validateParameter(valid_594721, JString, required = false,
                                 default = nil)
  if valid_594721 != nil:
    section.add "uploadType", valid_594721
  var valid_594722 = query.getOrDefault("key")
  valid_594722 = validateParameter(valid_594722, JString, required = false,
                                 default = nil)
  if valid_594722 != nil:
    section.add "key", valid_594722
  var valid_594723 = query.getOrDefault("$.xgafv")
  valid_594723 = validateParameter(valid_594723, JString, required = false,
                                 default = newJString("1"))
  if valid_594723 != nil:
    section.add "$.xgafv", valid_594723
  var valid_594724 = query.getOrDefault("prettyPrint")
  valid_594724 = validateParameter(valid_594724, JBool, required = false,
                                 default = newJBool(true))
  if valid_594724 != nil:
    section.add "prettyPrint", valid_594724
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

proc call*(call_594726: Call_RunProjectsLocationsServicesCreate_594710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a service.
  ## 
  let valid = call_594726.validator(path, query, header, formData, body)
  let scheme = call_594726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594726.url(scheme.get, call_594726.host, call_594726.base,
                         call_594726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594726, url, valid)

proc call*(call_594727: Call_RunProjectsLocationsServicesCreate_594710;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesCreate
  ## Create a service.
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
  ##   parent: string (required)
  ##         : The project ID or project number in which this service should be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594728 = newJObject()
  var query_594729 = newJObject()
  var body_594730 = newJObject()
  add(query_594729, "upload_protocol", newJString(uploadProtocol))
  add(query_594729, "fields", newJString(fields))
  add(query_594729, "quotaUser", newJString(quotaUser))
  add(query_594729, "alt", newJString(alt))
  add(query_594729, "oauth_token", newJString(oauthToken))
  add(query_594729, "callback", newJString(callback))
  add(query_594729, "access_token", newJString(accessToken))
  add(query_594729, "uploadType", newJString(uploadType))
  add(path_594728, "parent", newJString(parent))
  add(query_594729, "key", newJString(key))
  add(query_594729, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594730 = body
  add(query_594729, "prettyPrint", newJBool(prettyPrint))
  result = call_594727.call(path_594728, query_594729, nil, nil, body_594730)

var runProjectsLocationsServicesCreate* = Call_RunProjectsLocationsServicesCreate_594710(
    name: "runProjectsLocationsServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesCreate_594711, base: "/",
    url: url_RunProjectsLocationsServicesCreate_594712, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesList_594684 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsServicesList_594686(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesList_594685(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the services should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594687 = path.getOrDefault("parent")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = nil)
  if valid_594687 != nil:
    section.add "parent", valid_594687
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_594688 = query.getOrDefault("upload_protocol")
  valid_594688 = validateParameter(valid_594688, JString, required = false,
                                 default = nil)
  if valid_594688 != nil:
    section.add "upload_protocol", valid_594688
  var valid_594689 = query.getOrDefault("fields")
  valid_594689 = validateParameter(valid_594689, JString, required = false,
                                 default = nil)
  if valid_594689 != nil:
    section.add "fields", valid_594689
  var valid_594690 = query.getOrDefault("quotaUser")
  valid_594690 = validateParameter(valid_594690, JString, required = false,
                                 default = nil)
  if valid_594690 != nil:
    section.add "quotaUser", valid_594690
  var valid_594691 = query.getOrDefault("includeUninitialized")
  valid_594691 = validateParameter(valid_594691, JBool, required = false, default = nil)
  if valid_594691 != nil:
    section.add "includeUninitialized", valid_594691
  var valid_594692 = query.getOrDefault("alt")
  valid_594692 = validateParameter(valid_594692, JString, required = false,
                                 default = newJString("json"))
  if valid_594692 != nil:
    section.add "alt", valid_594692
  var valid_594693 = query.getOrDefault("continue")
  valid_594693 = validateParameter(valid_594693, JString, required = false,
                                 default = nil)
  if valid_594693 != nil:
    section.add "continue", valid_594693
  var valid_594694 = query.getOrDefault("oauth_token")
  valid_594694 = validateParameter(valid_594694, JString, required = false,
                                 default = nil)
  if valid_594694 != nil:
    section.add "oauth_token", valid_594694
  var valid_594695 = query.getOrDefault("callback")
  valid_594695 = validateParameter(valid_594695, JString, required = false,
                                 default = nil)
  if valid_594695 != nil:
    section.add "callback", valid_594695
  var valid_594696 = query.getOrDefault("access_token")
  valid_594696 = validateParameter(valid_594696, JString, required = false,
                                 default = nil)
  if valid_594696 != nil:
    section.add "access_token", valid_594696
  var valid_594697 = query.getOrDefault("uploadType")
  valid_594697 = validateParameter(valid_594697, JString, required = false,
                                 default = nil)
  if valid_594697 != nil:
    section.add "uploadType", valid_594697
  var valid_594698 = query.getOrDefault("resourceVersion")
  valid_594698 = validateParameter(valid_594698, JString, required = false,
                                 default = nil)
  if valid_594698 != nil:
    section.add "resourceVersion", valid_594698
  var valid_594699 = query.getOrDefault("watch")
  valid_594699 = validateParameter(valid_594699, JBool, required = false, default = nil)
  if valid_594699 != nil:
    section.add "watch", valid_594699
  var valid_594700 = query.getOrDefault("key")
  valid_594700 = validateParameter(valid_594700, JString, required = false,
                                 default = nil)
  if valid_594700 != nil:
    section.add "key", valid_594700
  var valid_594701 = query.getOrDefault("$.xgafv")
  valid_594701 = validateParameter(valid_594701, JString, required = false,
                                 default = newJString("1"))
  if valid_594701 != nil:
    section.add "$.xgafv", valid_594701
  var valid_594702 = query.getOrDefault("labelSelector")
  valid_594702 = validateParameter(valid_594702, JString, required = false,
                                 default = nil)
  if valid_594702 != nil:
    section.add "labelSelector", valid_594702
  var valid_594703 = query.getOrDefault("prettyPrint")
  valid_594703 = validateParameter(valid_594703, JBool, required = false,
                                 default = newJBool(true))
  if valid_594703 != nil:
    section.add "prettyPrint", valid_594703
  var valid_594704 = query.getOrDefault("fieldSelector")
  valid_594704 = validateParameter(valid_594704, JString, required = false,
                                 default = nil)
  if valid_594704 != nil:
    section.add "fieldSelector", valid_594704
  var valid_594705 = query.getOrDefault("limit")
  valid_594705 = validateParameter(valid_594705, JInt, required = false, default = nil)
  if valid_594705 != nil:
    section.add "limit", valid_594705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594706: Call_RunProjectsLocationsServicesList_594684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List services.
  ## 
  let valid = call_594706.validator(path, query, header, formData, body)
  let scheme = call_594706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594706.url(scheme.get, call_594706.host, call_594706.base,
                         call_594706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594706, url, valid)

proc call*(call_594707: Call_RunProjectsLocationsServicesList_594684;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsServicesList
  ## List services.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the services should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_594708 = newJObject()
  var query_594709 = newJObject()
  add(query_594709, "upload_protocol", newJString(uploadProtocol))
  add(query_594709, "fields", newJString(fields))
  add(query_594709, "quotaUser", newJString(quotaUser))
  add(query_594709, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594709, "alt", newJString(alt))
  add(query_594709, "continue", newJString(`continue`))
  add(query_594709, "oauth_token", newJString(oauthToken))
  add(query_594709, "callback", newJString(callback))
  add(query_594709, "access_token", newJString(accessToken))
  add(query_594709, "uploadType", newJString(uploadType))
  add(path_594708, "parent", newJString(parent))
  add(query_594709, "resourceVersion", newJString(resourceVersion))
  add(query_594709, "watch", newJBool(watch))
  add(query_594709, "key", newJString(key))
  add(query_594709, "$.xgafv", newJString(Xgafv))
  add(query_594709, "labelSelector", newJString(labelSelector))
  add(query_594709, "prettyPrint", newJBool(prettyPrint))
  add(query_594709, "fieldSelector", newJString(fieldSelector))
  add(query_594709, "limit", newJInt(limit))
  result = call_594707.call(path_594708, query_594709, nil, nil, nil)

var runProjectsLocationsServicesList* = Call_RunProjectsLocationsServicesList_594684(
    name: "runProjectsLocationsServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesList_594685, base: "/",
    url: url_RunProjectsLocationsServicesList_594686, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGetIamPolicy_594731 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsServicesGetIamPolicy_594733(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesGetIamPolicy_594732(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594734 = path.getOrDefault("resource")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "resource", valid_594734
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594735 = query.getOrDefault("upload_protocol")
  valid_594735 = validateParameter(valid_594735, JString, required = false,
                                 default = nil)
  if valid_594735 != nil:
    section.add "upload_protocol", valid_594735
  var valid_594736 = query.getOrDefault("fields")
  valid_594736 = validateParameter(valid_594736, JString, required = false,
                                 default = nil)
  if valid_594736 != nil:
    section.add "fields", valid_594736
  var valid_594737 = query.getOrDefault("quotaUser")
  valid_594737 = validateParameter(valid_594737, JString, required = false,
                                 default = nil)
  if valid_594737 != nil:
    section.add "quotaUser", valid_594737
  var valid_594738 = query.getOrDefault("alt")
  valid_594738 = validateParameter(valid_594738, JString, required = false,
                                 default = newJString("json"))
  if valid_594738 != nil:
    section.add "alt", valid_594738
  var valid_594739 = query.getOrDefault("oauth_token")
  valid_594739 = validateParameter(valid_594739, JString, required = false,
                                 default = nil)
  if valid_594739 != nil:
    section.add "oauth_token", valid_594739
  var valid_594740 = query.getOrDefault("callback")
  valid_594740 = validateParameter(valid_594740, JString, required = false,
                                 default = nil)
  if valid_594740 != nil:
    section.add "callback", valid_594740
  var valid_594741 = query.getOrDefault("access_token")
  valid_594741 = validateParameter(valid_594741, JString, required = false,
                                 default = nil)
  if valid_594741 != nil:
    section.add "access_token", valid_594741
  var valid_594742 = query.getOrDefault("uploadType")
  valid_594742 = validateParameter(valid_594742, JString, required = false,
                                 default = nil)
  if valid_594742 != nil:
    section.add "uploadType", valid_594742
  var valid_594743 = query.getOrDefault("options.requestedPolicyVersion")
  valid_594743 = validateParameter(valid_594743, JInt, required = false, default = nil)
  if valid_594743 != nil:
    section.add "options.requestedPolicyVersion", valid_594743
  var valid_594744 = query.getOrDefault("key")
  valid_594744 = validateParameter(valid_594744, JString, required = false,
                                 default = nil)
  if valid_594744 != nil:
    section.add "key", valid_594744
  var valid_594745 = query.getOrDefault("$.xgafv")
  valid_594745 = validateParameter(valid_594745, JString, required = false,
                                 default = newJString("1"))
  if valid_594745 != nil:
    section.add "$.xgafv", valid_594745
  var valid_594746 = query.getOrDefault("prettyPrint")
  valid_594746 = validateParameter(valid_594746, JBool, required = false,
                                 default = newJBool(true))
  if valid_594746 != nil:
    section.add "prettyPrint", valid_594746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594747: Call_RunProjectsLocationsServicesGetIamPolicy_594731;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  let valid = call_594747.validator(path, query, header, formData, body)
  let scheme = call_594747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594747.url(scheme.get, call_594747.host, call_594747.base,
                         call_594747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594747, url, valid)

proc call*(call_594748: Call_RunProjectsLocationsServicesGetIamPolicy_594731;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesGetIamPolicy
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594749 = newJObject()
  var query_594750 = newJObject()
  add(query_594750, "upload_protocol", newJString(uploadProtocol))
  add(query_594750, "fields", newJString(fields))
  add(query_594750, "quotaUser", newJString(quotaUser))
  add(query_594750, "alt", newJString(alt))
  add(query_594750, "oauth_token", newJString(oauthToken))
  add(query_594750, "callback", newJString(callback))
  add(query_594750, "access_token", newJString(accessToken))
  add(query_594750, "uploadType", newJString(uploadType))
  add(query_594750, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_594750, "key", newJString(key))
  add(query_594750, "$.xgafv", newJString(Xgafv))
  add(path_594749, "resource", newJString(resource))
  add(query_594750, "prettyPrint", newJBool(prettyPrint))
  result = call_594748.call(path_594749, query_594750, nil, nil, nil)

var runProjectsLocationsServicesGetIamPolicy* = Call_RunProjectsLocationsServicesGetIamPolicy_594731(
    name: "runProjectsLocationsServicesGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_RunProjectsLocationsServicesGetIamPolicy_594732,
    base: "/", url: url_RunProjectsLocationsServicesGetIamPolicy_594733,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesSetIamPolicy_594751 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsServicesSetIamPolicy_594753(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesSetIamPolicy_594752(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594754 = path.getOrDefault("resource")
  valid_594754 = validateParameter(valid_594754, JString, required = true,
                                 default = nil)
  if valid_594754 != nil:
    section.add "resource", valid_594754
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
  var valid_594755 = query.getOrDefault("upload_protocol")
  valid_594755 = validateParameter(valid_594755, JString, required = false,
                                 default = nil)
  if valid_594755 != nil:
    section.add "upload_protocol", valid_594755
  var valid_594756 = query.getOrDefault("fields")
  valid_594756 = validateParameter(valid_594756, JString, required = false,
                                 default = nil)
  if valid_594756 != nil:
    section.add "fields", valid_594756
  var valid_594757 = query.getOrDefault("quotaUser")
  valid_594757 = validateParameter(valid_594757, JString, required = false,
                                 default = nil)
  if valid_594757 != nil:
    section.add "quotaUser", valid_594757
  var valid_594758 = query.getOrDefault("alt")
  valid_594758 = validateParameter(valid_594758, JString, required = false,
                                 default = newJString("json"))
  if valid_594758 != nil:
    section.add "alt", valid_594758
  var valid_594759 = query.getOrDefault("oauth_token")
  valid_594759 = validateParameter(valid_594759, JString, required = false,
                                 default = nil)
  if valid_594759 != nil:
    section.add "oauth_token", valid_594759
  var valid_594760 = query.getOrDefault("callback")
  valid_594760 = validateParameter(valid_594760, JString, required = false,
                                 default = nil)
  if valid_594760 != nil:
    section.add "callback", valid_594760
  var valid_594761 = query.getOrDefault("access_token")
  valid_594761 = validateParameter(valid_594761, JString, required = false,
                                 default = nil)
  if valid_594761 != nil:
    section.add "access_token", valid_594761
  var valid_594762 = query.getOrDefault("uploadType")
  valid_594762 = validateParameter(valid_594762, JString, required = false,
                                 default = nil)
  if valid_594762 != nil:
    section.add "uploadType", valid_594762
  var valid_594763 = query.getOrDefault("key")
  valid_594763 = validateParameter(valid_594763, JString, required = false,
                                 default = nil)
  if valid_594763 != nil:
    section.add "key", valid_594763
  var valid_594764 = query.getOrDefault("$.xgafv")
  valid_594764 = validateParameter(valid_594764, JString, required = false,
                                 default = newJString("1"))
  if valid_594764 != nil:
    section.add "$.xgafv", valid_594764
  var valid_594765 = query.getOrDefault("prettyPrint")
  valid_594765 = validateParameter(valid_594765, JBool, required = false,
                                 default = newJBool(true))
  if valid_594765 != nil:
    section.add "prettyPrint", valid_594765
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

proc call*(call_594767: Call_RunProjectsLocationsServicesSetIamPolicy_594751;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  let valid = call_594767.validator(path, query, header, formData, body)
  let scheme = call_594767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594767.url(scheme.get, call_594767.host, call_594767.base,
                         call_594767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594767, url, valid)

proc call*(call_594768: Call_RunProjectsLocationsServicesSetIamPolicy_594751;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesSetIamPolicy
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594769 = newJObject()
  var query_594770 = newJObject()
  var body_594771 = newJObject()
  add(query_594770, "upload_protocol", newJString(uploadProtocol))
  add(query_594770, "fields", newJString(fields))
  add(query_594770, "quotaUser", newJString(quotaUser))
  add(query_594770, "alt", newJString(alt))
  add(query_594770, "oauth_token", newJString(oauthToken))
  add(query_594770, "callback", newJString(callback))
  add(query_594770, "access_token", newJString(accessToken))
  add(query_594770, "uploadType", newJString(uploadType))
  add(query_594770, "key", newJString(key))
  add(query_594770, "$.xgafv", newJString(Xgafv))
  add(path_594769, "resource", newJString(resource))
  if body != nil:
    body_594771 = body
  add(query_594770, "prettyPrint", newJBool(prettyPrint))
  result = call_594768.call(path_594769, query_594770, nil, nil, body_594771)

var runProjectsLocationsServicesSetIamPolicy* = Call_RunProjectsLocationsServicesSetIamPolicy_594751(
    name: "runProjectsLocationsServicesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_RunProjectsLocationsServicesSetIamPolicy_594752,
    base: "/", url: url_RunProjectsLocationsServicesSetIamPolicy_594753,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesTestIamPermissions_594772 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsServicesTestIamPermissions_594774(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesTestIamPermissions_594773(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594775 = path.getOrDefault("resource")
  valid_594775 = validateParameter(valid_594775, JString, required = true,
                                 default = nil)
  if valid_594775 != nil:
    section.add "resource", valid_594775
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
  var valid_594776 = query.getOrDefault("upload_protocol")
  valid_594776 = validateParameter(valid_594776, JString, required = false,
                                 default = nil)
  if valid_594776 != nil:
    section.add "upload_protocol", valid_594776
  var valid_594777 = query.getOrDefault("fields")
  valid_594777 = validateParameter(valid_594777, JString, required = false,
                                 default = nil)
  if valid_594777 != nil:
    section.add "fields", valid_594777
  var valid_594778 = query.getOrDefault("quotaUser")
  valid_594778 = validateParameter(valid_594778, JString, required = false,
                                 default = nil)
  if valid_594778 != nil:
    section.add "quotaUser", valid_594778
  var valid_594779 = query.getOrDefault("alt")
  valid_594779 = validateParameter(valid_594779, JString, required = false,
                                 default = newJString("json"))
  if valid_594779 != nil:
    section.add "alt", valid_594779
  var valid_594780 = query.getOrDefault("oauth_token")
  valid_594780 = validateParameter(valid_594780, JString, required = false,
                                 default = nil)
  if valid_594780 != nil:
    section.add "oauth_token", valid_594780
  var valid_594781 = query.getOrDefault("callback")
  valid_594781 = validateParameter(valid_594781, JString, required = false,
                                 default = nil)
  if valid_594781 != nil:
    section.add "callback", valid_594781
  var valid_594782 = query.getOrDefault("access_token")
  valid_594782 = validateParameter(valid_594782, JString, required = false,
                                 default = nil)
  if valid_594782 != nil:
    section.add "access_token", valid_594782
  var valid_594783 = query.getOrDefault("uploadType")
  valid_594783 = validateParameter(valid_594783, JString, required = false,
                                 default = nil)
  if valid_594783 != nil:
    section.add "uploadType", valid_594783
  var valid_594784 = query.getOrDefault("key")
  valid_594784 = validateParameter(valid_594784, JString, required = false,
                                 default = nil)
  if valid_594784 != nil:
    section.add "key", valid_594784
  var valid_594785 = query.getOrDefault("$.xgafv")
  valid_594785 = validateParameter(valid_594785, JString, required = false,
                                 default = newJString("1"))
  if valid_594785 != nil:
    section.add "$.xgafv", valid_594785
  var valid_594786 = query.getOrDefault("prettyPrint")
  valid_594786 = validateParameter(valid_594786, JBool, required = false,
                                 default = newJBool(true))
  if valid_594786 != nil:
    section.add "prettyPrint", valid_594786
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

proc call*(call_594788: Call_RunProjectsLocationsServicesTestIamPermissions_594772;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_594788.validator(path, query, header, formData, body)
  let scheme = call_594788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594788.url(scheme.get, call_594788.host, call_594788.base,
                         call_594788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594788, url, valid)

proc call*(call_594789: Call_RunProjectsLocationsServicesTestIamPermissions_594772;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesTestIamPermissions
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594790 = newJObject()
  var query_594791 = newJObject()
  var body_594792 = newJObject()
  add(query_594791, "upload_protocol", newJString(uploadProtocol))
  add(query_594791, "fields", newJString(fields))
  add(query_594791, "quotaUser", newJString(quotaUser))
  add(query_594791, "alt", newJString(alt))
  add(query_594791, "oauth_token", newJString(oauthToken))
  add(query_594791, "callback", newJString(callback))
  add(query_594791, "access_token", newJString(accessToken))
  add(query_594791, "uploadType", newJString(uploadType))
  add(query_594791, "key", newJString(key))
  add(query_594791, "$.xgafv", newJString(Xgafv))
  add(path_594790, "resource", newJString(resource))
  if body != nil:
    body_594792 = body
  add(query_594791, "prettyPrint", newJBool(prettyPrint))
  result = call_594789.call(path_594790, query_594791, nil, nil, body_594792)

var runProjectsLocationsServicesTestIamPermissions* = Call_RunProjectsLocationsServicesTestIamPermissions_594772(
    name: "runProjectsLocationsServicesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_RunProjectsLocationsServicesTestIamPermissions_594773,
    base: "/", url: url_RunProjectsLocationsServicesTestIamPermissions_594774,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
