
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Storage
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Lets you store and retrieve potentially-large, immutable data objects.
## 
## https://developers.google.com/storage/docs/json_api/
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
  gcpServiceName = "storage"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageBucketsInsert_578897 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsInsert_578899(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageBucketsInsert_578898(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new bucket.
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
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578900 = query.getOrDefault("key")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "key", valid_578900
  var valid_578901 = query.getOrDefault("prettyPrint")
  valid_578901 = validateParameter(valid_578901, JBool, required = false,
                                 default = newJBool(true))
  if valid_578901 != nil:
    section.add "prettyPrint", valid_578901
  var valid_578902 = query.getOrDefault("oauth_token")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "oauth_token", valid_578902
  var valid_578903 = query.getOrDefault("alt")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = newJString("json"))
  if valid_578903 != nil:
    section.add "alt", valid_578903
  var valid_578904 = query.getOrDefault("userIp")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "userIp", valid_578904
  var valid_578905 = query.getOrDefault("quotaUser")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "quotaUser", valid_578905
  var valid_578906 = query.getOrDefault("projection")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("full"))
  if valid_578906 != nil:
    section.add "projection", valid_578906
  var valid_578907 = query.getOrDefault("fields")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "fields", valid_578907
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

proc call*(call_578909: Call_StorageBucketsInsert_578897; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_578909.validator(path, query, header, formData, body)
  let scheme = call_578909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578909.url(scheme.get, call_578909.host, call_578909.base,
                         call_578909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578909, url, valid)

proc call*(call_578910: Call_StorageBucketsInsert_578897; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          projection: string = "full"; fields: string = ""): Recallable =
  ## storageBucketsInsert
  ## Creates a new bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578911 = newJObject()
  var body_578912 = newJObject()
  add(query_578911, "key", newJString(key))
  add(query_578911, "prettyPrint", newJBool(prettyPrint))
  add(query_578911, "oauth_token", newJString(oauthToken))
  add(query_578911, "alt", newJString(alt))
  add(query_578911, "userIp", newJString(userIp))
  add(query_578911, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578912 = body
  add(query_578911, "projection", newJString(projection))
  add(query_578911, "fields", newJString(fields))
  result = call_578910.call(nil, query_578911, nil, nil, body_578912)

var storageBucketsInsert* = Call_StorageBucketsInsert_578897(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_578898, base: "/storage/v1beta1",
    url: url_StorageBucketsInsert_578899, schemes: {Scheme.Https})
type
  Call_StorageBucketsList_578625 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsList_578627(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageBucketsList_578626(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of buckets for a given project.
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
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   max-results: JInt
  ##              : Maximum number of buckets to return.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   projectId: JString (required)
  ##            : A valid API project identifier.
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
  var valid_578755 = query.getOrDefault("alt")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("json"))
  if valid_578755 != nil:
    section.add "alt", valid_578755
  var valid_578756 = query.getOrDefault("userIp")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "userIp", valid_578756
  var valid_578757 = query.getOrDefault("quotaUser")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "quotaUser", valid_578757
  var valid_578758 = query.getOrDefault("pageToken")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "pageToken", valid_578758
  var valid_578759 = query.getOrDefault("max-results")
  valid_578759 = validateParameter(valid_578759, JInt, required = false, default = nil)
  if valid_578759 != nil:
    section.add "max-results", valid_578759
  var valid_578760 = query.getOrDefault("projection")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = newJString("full"))
  if valid_578760 != nil:
    section.add "projection", valid_578760
  var valid_578761 = query.getOrDefault("fields")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "fields", valid_578761
  assert query != nil,
        "query argument is necessary due to required `projectId` field"
  var valid_578762 = query.getOrDefault("projectId")
  valid_578762 = validateParameter(valid_578762, JString, required = true,
                                 default = nil)
  if valid_578762 != nil:
    section.add "projectId", valid_578762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578785: Call_StorageBucketsList_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of buckets for a given project.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_StorageBucketsList_578625; projectId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; maxResults: int = 0; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageBucketsList
  ## Retrieves a list of buckets for a given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   maxResults: int
  ##             : Maximum number of buckets to return.
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   projectId: string (required)
  ##            : A valid API project identifier.
  var query_578857 = newJObject()
  add(query_578857, "key", newJString(key))
  add(query_578857, "prettyPrint", newJBool(prettyPrint))
  add(query_578857, "oauth_token", newJString(oauthToken))
  add(query_578857, "alt", newJString(alt))
  add(query_578857, "userIp", newJString(userIp))
  add(query_578857, "quotaUser", newJString(quotaUser))
  add(query_578857, "pageToken", newJString(pageToken))
  add(query_578857, "max-results", newJInt(maxResults))
  add(query_578857, "projection", newJString(projection))
  add(query_578857, "fields", newJString(fields))
  add(query_578857, "projectId", newJString(projectId))
  result = call_578856.call(nil, query_578857, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_578625(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsList_578626, base: "/storage/v1beta1",
    url: url_StorageBucketsList_578627, schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_578943 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsUpdate_578945(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsUpdate_578944(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_578946 = path.getOrDefault("bucket")
  valid_578946 = validateParameter(valid_578946, JString, required = true,
                                 default = nil)
  if valid_578946 != nil:
    section.add "bucket", valid_578946
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578947 = query.getOrDefault("key")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "key", valid_578947
  var valid_578948 = query.getOrDefault("prettyPrint")
  valid_578948 = validateParameter(valid_578948, JBool, required = false,
                                 default = newJBool(true))
  if valid_578948 != nil:
    section.add "prettyPrint", valid_578948
  var valid_578949 = query.getOrDefault("oauth_token")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "oauth_token", valid_578949
  var valid_578950 = query.getOrDefault("alt")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = newJString("json"))
  if valid_578950 != nil:
    section.add "alt", valid_578950
  var valid_578951 = query.getOrDefault("userIp")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "userIp", valid_578951
  var valid_578952 = query.getOrDefault("quotaUser")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "quotaUser", valid_578952
  var valid_578953 = query.getOrDefault("projection")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = newJString("full"))
  if valid_578953 != nil:
    section.add "projection", valid_578953
  var valid_578954 = query.getOrDefault("fields")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "fields", valid_578954
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

proc call*(call_578956: Call_StorageBucketsUpdate_578943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket.
  ## 
  let valid = call_578956.validator(path, query, header, formData, body)
  let scheme = call_578956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578956.url(scheme.get, call_578956.host, call_578956.base,
                         call_578956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578956, url, valid)

proc call*(call_578957: Call_StorageBucketsUpdate_578943; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; projection: string = "full"; fields: string = ""): Recallable =
  ## storageBucketsUpdate
  ## Updates a bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578958 = newJObject()
  var query_578959 = newJObject()
  var body_578960 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "userIp", newJString(userIp))
  add(query_578959, "quotaUser", newJString(quotaUser))
  add(path_578958, "bucket", newJString(bucket))
  if body != nil:
    body_578960 = body
  add(query_578959, "projection", newJString(projection))
  add(query_578959, "fields", newJString(fields))
  result = call_578957.call(path_578958, query_578959, nil, nil, body_578960)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_578943(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_578944, base: "/storage/v1beta1",
    url: url_StorageBucketsUpdate_578945, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_578913 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsGet_578915(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsGet_578914(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns metadata for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_578930 = path.getOrDefault("bucket")
  valid_578930 = validateParameter(valid_578930, JString, required = true,
                                 default = nil)
  if valid_578930 != nil:
    section.add "bucket", valid_578930
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_578934 = query.getOrDefault("alt")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("json"))
  if valid_578934 != nil:
    section.add "alt", valid_578934
  var valid_578935 = query.getOrDefault("userIp")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "userIp", valid_578935
  var valid_578936 = query.getOrDefault("quotaUser")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "quotaUser", valid_578936
  var valid_578937 = query.getOrDefault("projection")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("full"))
  if valid_578937 != nil:
    section.add "projection", valid_578937
  var valid_578938 = query.getOrDefault("fields")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "fields", valid_578938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578939: Call_StorageBucketsGet_578913; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_578939.validator(path, query, header, formData, body)
  let scheme = call_578939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578939.url(scheme.get, call_578939.host, call_578939.base,
                         call_578939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578939, url, valid)

proc call*(call_578940: Call_StorageBucketsGet_578913; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          projection: string = "full"; fields: string = ""): Recallable =
  ## storageBucketsGet
  ## Returns metadata for the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578941 = newJObject()
  var query_578942 = newJObject()
  add(query_578942, "key", newJString(key))
  add(query_578942, "prettyPrint", newJBool(prettyPrint))
  add(query_578942, "oauth_token", newJString(oauthToken))
  add(query_578942, "alt", newJString(alt))
  add(query_578942, "userIp", newJString(userIp))
  add(query_578942, "quotaUser", newJString(quotaUser))
  add(path_578941, "bucket", newJString(bucket))
  add(query_578942, "projection", newJString(projection))
  add(query_578942, "fields", newJString(fields))
  result = call_578940.call(path_578941, query_578942, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_578913(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_578914, base: "/storage/v1beta1",
    url: url_StorageBucketsGet_578915, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_578976 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsPatch_578978(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsPatch_578977(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a bucket. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_578979 = path.getOrDefault("bucket")
  valid_578979 = validateParameter(valid_578979, JString, required = true,
                                 default = nil)
  if valid_578979 != nil:
    section.add "bucket", valid_578979
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578980 = query.getOrDefault("key")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "key", valid_578980
  var valid_578981 = query.getOrDefault("prettyPrint")
  valid_578981 = validateParameter(valid_578981, JBool, required = false,
                                 default = newJBool(true))
  if valid_578981 != nil:
    section.add "prettyPrint", valid_578981
  var valid_578982 = query.getOrDefault("oauth_token")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "oauth_token", valid_578982
  var valid_578983 = query.getOrDefault("alt")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = newJString("json"))
  if valid_578983 != nil:
    section.add "alt", valid_578983
  var valid_578984 = query.getOrDefault("userIp")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "userIp", valid_578984
  var valid_578985 = query.getOrDefault("quotaUser")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "quotaUser", valid_578985
  var valid_578986 = query.getOrDefault("projection")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("full"))
  if valid_578986 != nil:
    section.add "projection", valid_578986
  var valid_578987 = query.getOrDefault("fields")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "fields", valid_578987
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

proc call*(call_578989: Call_StorageBucketsPatch_578976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. This method supports patch semantics.
  ## 
  let valid = call_578989.validator(path, query, header, formData, body)
  let scheme = call_578989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578989.url(scheme.get, call_578989.host, call_578989.base,
                         call_578989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578989, url, valid)

proc call*(call_578990: Call_StorageBucketsPatch_578976; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; projection: string = "full"; fields: string = ""): Recallable =
  ## storageBucketsPatch
  ## Updates a bucket. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578991 = newJObject()
  var query_578992 = newJObject()
  var body_578993 = newJObject()
  add(query_578992, "key", newJString(key))
  add(query_578992, "prettyPrint", newJBool(prettyPrint))
  add(query_578992, "oauth_token", newJString(oauthToken))
  add(query_578992, "alt", newJString(alt))
  add(query_578992, "userIp", newJString(userIp))
  add(query_578992, "quotaUser", newJString(quotaUser))
  add(path_578991, "bucket", newJString(bucket))
  if body != nil:
    body_578993 = body
  add(query_578992, "projection", newJString(projection))
  add(query_578992, "fields", newJString(fields))
  result = call_578990.call(path_578991, query_578992, nil, nil, body_578993)

var storageBucketsPatch* = Call_StorageBucketsPatch_578976(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_578977, base: "/storage/v1beta1",
    url: url_StorageBucketsPatch_578978, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_578961 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsDelete_578963(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsDelete_578962(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an empty bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_578964 = path.getOrDefault("bucket")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "bucket", valid_578964
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_578968 = query.getOrDefault("alt")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("json"))
  if valid_578968 != nil:
    section.add "alt", valid_578968
  var valid_578969 = query.getOrDefault("userIp")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "userIp", valid_578969
  var valid_578970 = query.getOrDefault("quotaUser")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "quotaUser", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578972: Call_StorageBucketsDelete_578961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an empty bucket.
  ## 
  let valid = call_578972.validator(path, query, header, formData, body)
  let scheme = call_578972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578972.url(scheme.get, call_578972.host, call_578972.base,
                         call_578972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578972, url, valid)

proc call*(call_578973: Call_StorageBucketsDelete_578961; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## storageBucketsDelete
  ## Deletes an empty bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578974 = newJObject()
  var query_578975 = newJObject()
  add(query_578975, "key", newJString(key))
  add(query_578975, "prettyPrint", newJBool(prettyPrint))
  add(query_578975, "oauth_token", newJString(oauthToken))
  add(query_578975, "alt", newJString(alt))
  add(query_578975, "userIp", newJString(userIp))
  add(query_578975, "quotaUser", newJString(quotaUser))
  add(path_578974, "bucket", newJString(bucket))
  add(query_578975, "fields", newJString(fields))
  result = call_578973.call(path_578974, query_578975, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_578961(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_578962, base: "/storage/v1beta1",
    url: url_StorageBucketsDelete_578963, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_579009 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsInsert_579011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsInsert_579010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579012 = path.getOrDefault("bucket")
  valid_579012 = validateParameter(valid_579012, JString, required = true,
                                 default = nil)
  if valid_579012 != nil:
    section.add "bucket", valid_579012
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_579016 = query.getOrDefault("alt")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = newJString("json"))
  if valid_579016 != nil:
    section.add "alt", valid_579016
  var valid_579017 = query.getOrDefault("userIp")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "userIp", valid_579017
  var valid_579018 = query.getOrDefault("quotaUser")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "quotaUser", valid_579018
  var valid_579019 = query.getOrDefault("fields")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "fields", valid_579019
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

proc call*(call_579021: Call_StorageBucketAccessControlsInsert_579009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_579021.validator(path, query, header, formData, body)
  let scheme = call_579021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579021.url(scheme.get, call_579021.host, call_579021.base,
                         call_579021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579021, url, valid)

proc call*(call_579022: Call_StorageBucketAccessControlsInsert_579009;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageBucketAccessControlsInsert
  ## Creates a new ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579023 = newJObject()
  var query_579024 = newJObject()
  var body_579025 = newJObject()
  add(query_579024, "key", newJString(key))
  add(query_579024, "prettyPrint", newJBool(prettyPrint))
  add(query_579024, "oauth_token", newJString(oauthToken))
  add(query_579024, "alt", newJString(alt))
  add(query_579024, "userIp", newJString(userIp))
  add(query_579024, "quotaUser", newJString(quotaUser))
  add(path_579023, "bucket", newJString(bucket))
  if body != nil:
    body_579025 = body
  add(query_579024, "fields", newJString(fields))
  result = call_579022.call(path_579023, query_579024, nil, nil, body_579025)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_579009(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_579010,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsInsert_579011,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_578994 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsList_578996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsList_578995(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_578997 = path.getOrDefault("bucket")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "bucket", valid_578997
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_579001 = query.getOrDefault("alt")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("json"))
  if valid_579001 != nil:
    section.add "alt", valid_579001
  var valid_579002 = query.getOrDefault("userIp")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "userIp", valid_579002
  var valid_579003 = query.getOrDefault("quotaUser")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "quotaUser", valid_579003
  var valid_579004 = query.getOrDefault("fields")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "fields", valid_579004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579005: Call_StorageBucketAccessControlsList_578994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_579005.validator(path, query, header, formData, body)
  let scheme = call_579005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579005.url(scheme.get, call_579005.host, call_579005.base,
                         call_579005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579005, url, valid)

proc call*(call_579006: Call_StorageBucketAccessControlsList_578994;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsList
  ## Retrieves ACL entries on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579007 = newJObject()
  var query_579008 = newJObject()
  add(query_579008, "key", newJString(key))
  add(query_579008, "prettyPrint", newJBool(prettyPrint))
  add(query_579008, "oauth_token", newJString(oauthToken))
  add(query_579008, "alt", newJString(alt))
  add(query_579008, "userIp", newJString(userIp))
  add(query_579008, "quotaUser", newJString(quotaUser))
  add(path_579007, "bucket", newJString(bucket))
  add(query_579008, "fields", newJString(fields))
  result = call_579006.call(path_579007, query_579008, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_578994(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_578995,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsList_578996,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_579042 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsUpdate_579044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsUpdate_579043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579045 = path.getOrDefault("bucket")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "bucket", valid_579045
  var valid_579046 = path.getOrDefault("entity")
  valid_579046 = validateParameter(valid_579046, JString, required = true,
                                 default = nil)
  if valid_579046 != nil:
    section.add "entity", valid_579046
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579047 = query.getOrDefault("key")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "key", valid_579047
  var valid_579048 = query.getOrDefault("prettyPrint")
  valid_579048 = validateParameter(valid_579048, JBool, required = false,
                                 default = newJBool(true))
  if valid_579048 != nil:
    section.add "prettyPrint", valid_579048
  var valid_579049 = query.getOrDefault("oauth_token")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "oauth_token", valid_579049
  var valid_579050 = query.getOrDefault("alt")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("json"))
  if valid_579050 != nil:
    section.add "alt", valid_579050
  var valid_579051 = query.getOrDefault("userIp")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "userIp", valid_579051
  var valid_579052 = query.getOrDefault("quotaUser")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "quotaUser", valid_579052
  var valid_579053 = query.getOrDefault("fields")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "fields", valid_579053
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

proc call*(call_579055: Call_StorageBucketAccessControlsUpdate_579042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_579055.validator(path, query, header, formData, body)
  let scheme = call_579055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579055.url(scheme.get, call_579055.host, call_579055.base,
                         call_579055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579055, url, valid)

proc call*(call_579056: Call_StorageBucketAccessControlsUpdate_579042;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageBucketAccessControlsUpdate
  ## Updates an ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579057 = newJObject()
  var query_579058 = newJObject()
  var body_579059 = newJObject()
  add(query_579058, "key", newJString(key))
  add(query_579058, "prettyPrint", newJBool(prettyPrint))
  add(query_579058, "oauth_token", newJString(oauthToken))
  add(query_579058, "alt", newJString(alt))
  add(query_579058, "userIp", newJString(userIp))
  add(query_579058, "quotaUser", newJString(quotaUser))
  add(path_579057, "bucket", newJString(bucket))
  if body != nil:
    body_579059 = body
  add(path_579057, "entity", newJString(entity))
  add(query_579058, "fields", newJString(fields))
  result = call_579056.call(path_579057, query_579058, nil, nil, body_579059)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_579042(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_579043,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsUpdate_579044,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_579026 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsGet_579028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsGet_579027(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579029 = path.getOrDefault("bucket")
  valid_579029 = validateParameter(valid_579029, JString, required = true,
                                 default = nil)
  if valid_579029 != nil:
    section.add "bucket", valid_579029
  var valid_579030 = path.getOrDefault("entity")
  valid_579030 = validateParameter(valid_579030, JString, required = true,
                                 default = nil)
  if valid_579030 != nil:
    section.add "entity", valid_579030
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579031 = query.getOrDefault("key")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "key", valid_579031
  var valid_579032 = query.getOrDefault("prettyPrint")
  valid_579032 = validateParameter(valid_579032, JBool, required = false,
                                 default = newJBool(true))
  if valid_579032 != nil:
    section.add "prettyPrint", valid_579032
  var valid_579033 = query.getOrDefault("oauth_token")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "oauth_token", valid_579033
  var valid_579034 = query.getOrDefault("alt")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = newJString("json"))
  if valid_579034 != nil:
    section.add "alt", valid_579034
  var valid_579035 = query.getOrDefault("userIp")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "userIp", valid_579035
  var valid_579036 = query.getOrDefault("quotaUser")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "quotaUser", valid_579036
  var valid_579037 = query.getOrDefault("fields")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "fields", valid_579037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579038: Call_StorageBucketAccessControlsGet_579026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_579038.validator(path, query, header, formData, body)
  let scheme = call_579038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579038.url(scheme.get, call_579038.host, call_579038.base,
                         call_579038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579038, url, valid)

proc call*(call_579039: Call_StorageBucketAccessControlsGet_579026; bucket: string;
          entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579040 = newJObject()
  var query_579041 = newJObject()
  add(query_579041, "key", newJString(key))
  add(query_579041, "prettyPrint", newJBool(prettyPrint))
  add(query_579041, "oauth_token", newJString(oauthToken))
  add(query_579041, "alt", newJString(alt))
  add(query_579041, "userIp", newJString(userIp))
  add(query_579041, "quotaUser", newJString(quotaUser))
  add(path_579040, "bucket", newJString(bucket))
  add(path_579040, "entity", newJString(entity))
  add(query_579041, "fields", newJString(fields))
  result = call_579039.call(path_579040, query_579041, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_579026(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_579027,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsGet_579028,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_579076 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsPatch_579078(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsPatch_579077(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579079 = path.getOrDefault("bucket")
  valid_579079 = validateParameter(valid_579079, JString, required = true,
                                 default = nil)
  if valid_579079 != nil:
    section.add "bucket", valid_579079
  var valid_579080 = path.getOrDefault("entity")
  valid_579080 = validateParameter(valid_579080, JString, required = true,
                                 default = nil)
  if valid_579080 != nil:
    section.add "entity", valid_579080
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579081 = query.getOrDefault("key")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "key", valid_579081
  var valid_579082 = query.getOrDefault("prettyPrint")
  valid_579082 = validateParameter(valid_579082, JBool, required = false,
                                 default = newJBool(true))
  if valid_579082 != nil:
    section.add "prettyPrint", valid_579082
  var valid_579083 = query.getOrDefault("oauth_token")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "oauth_token", valid_579083
  var valid_579084 = query.getOrDefault("alt")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = newJString("json"))
  if valid_579084 != nil:
    section.add "alt", valid_579084
  var valid_579085 = query.getOrDefault("userIp")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "userIp", valid_579085
  var valid_579086 = query.getOrDefault("quotaUser")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "quotaUser", valid_579086
  var valid_579087 = query.getOrDefault("fields")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "fields", valid_579087
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

proc call*(call_579089: Call_StorageBucketAccessControlsPatch_579076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  let valid = call_579089.validator(path, query, header, formData, body)
  let scheme = call_579089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579089.url(scheme.get, call_579089.host, call_579089.base,
                         call_579089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579089, url, valid)

proc call*(call_579090: Call_StorageBucketAccessControlsPatch_579076;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageBucketAccessControlsPatch
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579091 = newJObject()
  var query_579092 = newJObject()
  var body_579093 = newJObject()
  add(query_579092, "key", newJString(key))
  add(query_579092, "prettyPrint", newJBool(prettyPrint))
  add(query_579092, "oauth_token", newJString(oauthToken))
  add(query_579092, "alt", newJString(alt))
  add(query_579092, "userIp", newJString(userIp))
  add(query_579092, "quotaUser", newJString(quotaUser))
  add(path_579091, "bucket", newJString(bucket))
  if body != nil:
    body_579093 = body
  add(path_579091, "entity", newJString(entity))
  add(query_579092, "fields", newJString(fields))
  result = call_579090.call(path_579091, query_579092, nil, nil, body_579093)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_579076(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_579077,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsPatch_579078,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_579060 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsDelete_579062(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsDelete_579061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579063 = path.getOrDefault("bucket")
  valid_579063 = validateParameter(valid_579063, JString, required = true,
                                 default = nil)
  if valid_579063 != nil:
    section.add "bucket", valid_579063
  var valid_579064 = path.getOrDefault("entity")
  valid_579064 = validateParameter(valid_579064, JString, required = true,
                                 default = nil)
  if valid_579064 != nil:
    section.add "entity", valid_579064
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579065 = query.getOrDefault("key")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "key", valid_579065
  var valid_579066 = query.getOrDefault("prettyPrint")
  valid_579066 = validateParameter(valid_579066, JBool, required = false,
                                 default = newJBool(true))
  if valid_579066 != nil:
    section.add "prettyPrint", valid_579066
  var valid_579067 = query.getOrDefault("oauth_token")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "oauth_token", valid_579067
  var valid_579068 = query.getOrDefault("alt")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = newJString("json"))
  if valid_579068 != nil:
    section.add "alt", valid_579068
  var valid_579069 = query.getOrDefault("userIp")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "userIp", valid_579069
  var valid_579070 = query.getOrDefault("quotaUser")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "quotaUser", valid_579070
  var valid_579071 = query.getOrDefault("fields")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "fields", valid_579071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579072: Call_StorageBucketAccessControlsDelete_579060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_579072.validator(path, query, header, formData, body)
  let scheme = call_579072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579072.url(scheme.get, call_579072.host, call_579072.base,
                         call_579072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579072, url, valid)

proc call*(call_579073: Call_StorageBucketAccessControlsDelete_579060;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsDelete
  ## Deletes the ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579074 = newJObject()
  var query_579075 = newJObject()
  add(query_579075, "key", newJString(key))
  add(query_579075, "prettyPrint", newJBool(prettyPrint))
  add(query_579075, "oauth_token", newJString(oauthToken))
  add(query_579075, "alt", newJString(alt))
  add(query_579075, "userIp", newJString(userIp))
  add(query_579075, "quotaUser", newJString(quotaUser))
  add(path_579074, "bucket", newJString(bucket))
  add(path_579074, "entity", newJString(entity))
  add(query_579075, "fields", newJString(fields))
  result = call_579073.call(path_579074, query_579075, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_579060(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_579061,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsDelete_579062,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_579114 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsInsert_579116(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsInsert_579115(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stores new data blobs and associated metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579117 = path.getOrDefault("bucket")
  valid_579117 = validateParameter(valid_579117, JString, required = true,
                                 default = nil)
  if valid_579117 != nil:
    section.add "bucket", valid_579117
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579118 = query.getOrDefault("key")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "key", valid_579118
  var valid_579119 = query.getOrDefault("prettyPrint")
  valid_579119 = validateParameter(valid_579119, JBool, required = false,
                                 default = newJBool(true))
  if valid_579119 != nil:
    section.add "prettyPrint", valid_579119
  var valid_579120 = query.getOrDefault("oauth_token")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "oauth_token", valid_579120
  var valid_579121 = query.getOrDefault("name")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "name", valid_579121
  var valid_579122 = query.getOrDefault("alt")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = newJString("json"))
  if valid_579122 != nil:
    section.add "alt", valid_579122
  var valid_579123 = query.getOrDefault("userIp")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "userIp", valid_579123
  var valid_579124 = query.getOrDefault("quotaUser")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "quotaUser", valid_579124
  var valid_579125 = query.getOrDefault("projection")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = newJString("full"))
  if valid_579125 != nil:
    section.add "projection", valid_579125
  var valid_579126 = query.getOrDefault("fields")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "fields", valid_579126
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

proc call*(call_579128: Call_StorageObjectsInsert_579114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores new data blobs and associated metadata.
  ## 
  let valid = call_579128.validator(path, query, header, formData, body)
  let scheme = call_579128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579128.url(scheme.get, call_579128.host, call_579128.base,
                         call_579128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579128, url, valid)

proc call*(call_579129: Call_StorageObjectsInsert_579114; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          name: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsInsert
  ## Stores new data blobs and associated metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   body: JObject
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579130 = newJObject()
  var query_579131 = newJObject()
  var body_579132 = newJObject()
  add(query_579131, "key", newJString(key))
  add(query_579131, "prettyPrint", newJBool(prettyPrint))
  add(query_579131, "oauth_token", newJString(oauthToken))
  add(query_579131, "name", newJString(name))
  add(query_579131, "alt", newJString(alt))
  add(query_579131, "userIp", newJString(userIp))
  add(query_579131, "quotaUser", newJString(quotaUser))
  add(path_579130, "bucket", newJString(bucket))
  if body != nil:
    body_579132 = body
  add(query_579131, "projection", newJString(projection))
  add(query_579131, "fields", newJString(fields))
  result = call_579129.call(path_579130, query_579131, nil, nil, body_579132)

var storageObjectsInsert* = Call_StorageObjectsInsert_579114(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_579115, base: "/storage/v1beta1",
    url: url_StorageObjectsInsert_579116, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_579094 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsList_579096(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsList_579095(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of objects matching the criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to look for objects.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579097 = path.getOrDefault("bucket")
  valid_579097 = validateParameter(valid_579097, JString, required = true,
                                 default = nil)
  if valid_579097 != nil:
    section.add "bucket", valid_579097
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   prefix: JString
  ##         : Filter results to objects whose names begin with this prefix.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   max-results: JInt
  ##              : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  section = newJObject()
  var valid_579098 = query.getOrDefault("key")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "key", valid_579098
  var valid_579099 = query.getOrDefault("prettyPrint")
  valid_579099 = validateParameter(valid_579099, JBool, required = false,
                                 default = newJBool(true))
  if valid_579099 != nil:
    section.add "prettyPrint", valid_579099
  var valid_579100 = query.getOrDefault("oauth_token")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "oauth_token", valid_579100
  var valid_579101 = query.getOrDefault("prefix")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "prefix", valid_579101
  var valid_579102 = query.getOrDefault("alt")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = newJString("json"))
  if valid_579102 != nil:
    section.add "alt", valid_579102
  var valid_579103 = query.getOrDefault("userIp")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "userIp", valid_579103
  var valid_579104 = query.getOrDefault("quotaUser")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "quotaUser", valid_579104
  var valid_579105 = query.getOrDefault("pageToken")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "pageToken", valid_579105
  var valid_579106 = query.getOrDefault("max-results")
  valid_579106 = validateParameter(valid_579106, JInt, required = false, default = nil)
  if valid_579106 != nil:
    section.add "max-results", valid_579106
  var valid_579107 = query.getOrDefault("projection")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = newJString("full"))
  if valid_579107 != nil:
    section.add "projection", valid_579107
  var valid_579108 = query.getOrDefault("fields")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "fields", valid_579108
  var valid_579109 = query.getOrDefault("delimiter")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "delimiter", valid_579109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579110: Call_StorageObjectsList_579094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_579110.validator(path, query, header, formData, body)
  let scheme = call_579110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579110.url(scheme.get, call_579110.host, call_579110.base,
                         call_579110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579110, url, valid)

proc call*(call_579111: Call_StorageObjectsList_579094; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          prefix: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; maxResults: int = 0;
          projection: string = "full"; fields: string = ""; delimiter: string = ""): Recallable =
  ## storageObjectsList
  ## Retrieves a list of objects matching the criteria.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   prefix: string
  ##         : Filter results to objects whose names begin with this prefix.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to look for objects.
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  var path_579112 = newJObject()
  var query_579113 = newJObject()
  add(query_579113, "key", newJString(key))
  add(query_579113, "prettyPrint", newJBool(prettyPrint))
  add(query_579113, "oauth_token", newJString(oauthToken))
  add(query_579113, "prefix", newJString(prefix))
  add(query_579113, "alt", newJString(alt))
  add(query_579113, "userIp", newJString(userIp))
  add(query_579113, "quotaUser", newJString(quotaUser))
  add(query_579113, "pageToken", newJString(pageToken))
  add(query_579113, "max-results", newJInt(maxResults))
  add(path_579112, "bucket", newJString(bucket))
  add(query_579113, "projection", newJString(projection))
  add(query_579113, "fields", newJString(fields))
  add(query_579113, "delimiter", newJString(delimiter))
  result = call_579111.call(path_579112, query_579113, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_579094(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_579095, base: "/storage/v1beta1",
    url: url_StorageObjectsList_579096, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_579150 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsUpdate_579152(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsUpdate_579151(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a data blob's associated metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579153 = path.getOrDefault("bucket")
  valid_579153 = validateParameter(valid_579153, JString, required = true,
                                 default = nil)
  if valid_579153 != nil:
    section.add "bucket", valid_579153
  var valid_579154 = path.getOrDefault("object")
  valid_579154 = validateParameter(valid_579154, JString, required = true,
                                 default = nil)
  if valid_579154 != nil:
    section.add "object", valid_579154
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579155 = query.getOrDefault("key")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "key", valid_579155
  var valid_579156 = query.getOrDefault("prettyPrint")
  valid_579156 = validateParameter(valid_579156, JBool, required = false,
                                 default = newJBool(true))
  if valid_579156 != nil:
    section.add "prettyPrint", valid_579156
  var valid_579157 = query.getOrDefault("oauth_token")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "oauth_token", valid_579157
  var valid_579158 = query.getOrDefault("alt")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = newJString("json"))
  if valid_579158 != nil:
    section.add "alt", valid_579158
  var valid_579159 = query.getOrDefault("userIp")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "userIp", valid_579159
  var valid_579160 = query.getOrDefault("quotaUser")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "quotaUser", valid_579160
  var valid_579161 = query.getOrDefault("projection")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("full"))
  if valid_579161 != nil:
    section.add "projection", valid_579161
  var valid_579162 = query.getOrDefault("fields")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "fields", valid_579162
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

proc call*(call_579164: Call_StorageObjectsUpdate_579150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata.
  ## 
  let valid = call_579164.validator(path, query, header, formData, body)
  let scheme = call_579164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579164.url(scheme.get, call_579164.host, call_579164.base,
                         call_579164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579164, url, valid)

proc call*(call_579165: Call_StorageObjectsUpdate_579150; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsUpdate
  ## Updates a data blob's associated metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   body: JObject
  ##   object: string (required)
  ##         : Name of the object.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579166 = newJObject()
  var query_579167 = newJObject()
  var body_579168 = newJObject()
  add(query_579167, "key", newJString(key))
  add(query_579167, "prettyPrint", newJBool(prettyPrint))
  add(query_579167, "oauth_token", newJString(oauthToken))
  add(query_579167, "alt", newJString(alt))
  add(query_579167, "userIp", newJString(userIp))
  add(query_579167, "quotaUser", newJString(quotaUser))
  add(path_579166, "bucket", newJString(bucket))
  if body != nil:
    body_579168 = body
  add(path_579166, "object", newJString(`object`))
  add(query_579167, "projection", newJString(projection))
  add(query_579167, "fields", newJString(fields))
  result = call_579165.call(path_579166, query_579167, nil, nil, body_579168)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_579150(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_579151, base: "/storage/v1beta1",
    url: url_StorageObjectsUpdate_579152, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_579133 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsGet_579135(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsGet_579134(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves objects or their associated metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579136 = path.getOrDefault("bucket")
  valid_579136 = validateParameter(valid_579136, JString, required = true,
                                 default = nil)
  if valid_579136 != nil:
    section.add "bucket", valid_579136
  var valid_579137 = path.getOrDefault("object")
  valid_579137 = validateParameter(valid_579137, JString, required = true,
                                 default = nil)
  if valid_579137 != nil:
    section.add "object", valid_579137
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579138 = query.getOrDefault("key")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "key", valid_579138
  var valid_579139 = query.getOrDefault("prettyPrint")
  valid_579139 = validateParameter(valid_579139, JBool, required = false,
                                 default = newJBool(true))
  if valid_579139 != nil:
    section.add "prettyPrint", valid_579139
  var valid_579140 = query.getOrDefault("oauth_token")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "oauth_token", valid_579140
  var valid_579141 = query.getOrDefault("alt")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = newJString("json"))
  if valid_579141 != nil:
    section.add "alt", valid_579141
  var valid_579142 = query.getOrDefault("userIp")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "userIp", valid_579142
  var valid_579143 = query.getOrDefault("quotaUser")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "quotaUser", valid_579143
  var valid_579144 = query.getOrDefault("projection")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = newJString("full"))
  if valid_579144 != nil:
    section.add "projection", valid_579144
  var valid_579145 = query.getOrDefault("fields")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "fields", valid_579145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579146: Call_StorageObjectsGet_579133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves objects or their associated metadata.
  ## 
  let valid = call_579146.validator(path, query, header, formData, body)
  let scheme = call_579146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579146.url(scheme.get, call_579146.host, call_579146.base,
                         call_579146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579146, url, valid)

proc call*(call_579147: Call_StorageObjectsGet_579133; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; projection: string = "full"; fields: string = ""): Recallable =
  ## storageObjectsGet
  ## Retrieves objects or their associated metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: string (required)
  ##         : Name of the object.
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579148 = newJObject()
  var query_579149 = newJObject()
  add(query_579149, "key", newJString(key))
  add(query_579149, "prettyPrint", newJBool(prettyPrint))
  add(query_579149, "oauth_token", newJString(oauthToken))
  add(query_579149, "alt", newJString(alt))
  add(query_579149, "userIp", newJString(userIp))
  add(query_579149, "quotaUser", newJString(quotaUser))
  add(path_579148, "bucket", newJString(bucket))
  add(path_579148, "object", newJString(`object`))
  add(query_579149, "projection", newJString(projection))
  add(query_579149, "fields", newJString(fields))
  result = call_579147.call(path_579148, query_579149, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_579133(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_579134,
    base: "/storage/v1beta1", url: url_StorageObjectsGet_579135,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_579185 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsPatch_579187(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsPatch_579186(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579188 = path.getOrDefault("bucket")
  valid_579188 = validateParameter(valid_579188, JString, required = true,
                                 default = nil)
  if valid_579188 != nil:
    section.add "bucket", valid_579188
  var valid_579189 = path.getOrDefault("object")
  valid_579189 = validateParameter(valid_579189, JString, required = true,
                                 default = nil)
  if valid_579189 != nil:
    section.add "object", valid_579189
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579190 = query.getOrDefault("key")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "key", valid_579190
  var valid_579191 = query.getOrDefault("prettyPrint")
  valid_579191 = validateParameter(valid_579191, JBool, required = false,
                                 default = newJBool(true))
  if valid_579191 != nil:
    section.add "prettyPrint", valid_579191
  var valid_579192 = query.getOrDefault("oauth_token")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "oauth_token", valid_579192
  var valid_579193 = query.getOrDefault("alt")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = newJString("json"))
  if valid_579193 != nil:
    section.add "alt", valid_579193
  var valid_579194 = query.getOrDefault("userIp")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "userIp", valid_579194
  var valid_579195 = query.getOrDefault("quotaUser")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "quotaUser", valid_579195
  var valid_579196 = query.getOrDefault("projection")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = newJString("full"))
  if valid_579196 != nil:
    section.add "projection", valid_579196
  var valid_579197 = query.getOrDefault("fields")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "fields", valid_579197
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

proc call*(call_579199: Call_StorageObjectsPatch_579185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ## 
  let valid = call_579199.validator(path, query, header, formData, body)
  let scheme = call_579199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579199.url(scheme.get, call_579199.host, call_579199.base,
                         call_579199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579199, url, valid)

proc call*(call_579200: Call_StorageObjectsPatch_579185; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsPatch
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   body: JObject
  ##   object: string (required)
  ##         : Name of the object.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579201 = newJObject()
  var query_579202 = newJObject()
  var body_579203 = newJObject()
  add(query_579202, "key", newJString(key))
  add(query_579202, "prettyPrint", newJBool(prettyPrint))
  add(query_579202, "oauth_token", newJString(oauthToken))
  add(query_579202, "alt", newJString(alt))
  add(query_579202, "userIp", newJString(userIp))
  add(query_579202, "quotaUser", newJString(quotaUser))
  add(path_579201, "bucket", newJString(bucket))
  if body != nil:
    body_579203 = body
  add(path_579201, "object", newJString(`object`))
  add(query_579202, "projection", newJString(projection))
  add(query_579202, "fields", newJString(fields))
  result = call_579200.call(path_579201, query_579202, nil, nil, body_579203)

var storageObjectsPatch* = Call_StorageObjectsPatch_579185(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_579186, base: "/storage/v1beta1",
    url: url_StorageObjectsPatch_579187, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_579169 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsDelete_579171(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsDelete_579170(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes data blobs and associated metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579172 = path.getOrDefault("bucket")
  valid_579172 = validateParameter(valid_579172, JString, required = true,
                                 default = nil)
  if valid_579172 != nil:
    section.add "bucket", valid_579172
  var valid_579173 = path.getOrDefault("object")
  valid_579173 = validateParameter(valid_579173, JString, required = true,
                                 default = nil)
  if valid_579173 != nil:
    section.add "object", valid_579173
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579174 = query.getOrDefault("key")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "key", valid_579174
  var valid_579175 = query.getOrDefault("prettyPrint")
  valid_579175 = validateParameter(valid_579175, JBool, required = false,
                                 default = newJBool(true))
  if valid_579175 != nil:
    section.add "prettyPrint", valid_579175
  var valid_579176 = query.getOrDefault("oauth_token")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "oauth_token", valid_579176
  var valid_579177 = query.getOrDefault("alt")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = newJString("json"))
  if valid_579177 != nil:
    section.add "alt", valid_579177
  var valid_579178 = query.getOrDefault("userIp")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "userIp", valid_579178
  var valid_579179 = query.getOrDefault("quotaUser")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "quotaUser", valid_579179
  var valid_579180 = query.getOrDefault("fields")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "fields", valid_579180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579181: Call_StorageObjectsDelete_579169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes data blobs and associated metadata.
  ## 
  let valid = call_579181.validator(path, query, header, formData, body)
  let scheme = call_579181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579181.url(scheme.get, call_579181.host, call_579181.base,
                         call_579181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579181, url, valid)

proc call*(call_579182: Call_StorageObjectsDelete_579169; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageObjectsDelete
  ## Deletes data blobs and associated metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579183 = newJObject()
  var query_579184 = newJObject()
  add(query_579184, "key", newJString(key))
  add(query_579184, "prettyPrint", newJBool(prettyPrint))
  add(query_579184, "oauth_token", newJString(oauthToken))
  add(query_579184, "alt", newJString(alt))
  add(query_579184, "userIp", newJString(userIp))
  add(query_579184, "quotaUser", newJString(quotaUser))
  add(path_579183, "bucket", newJString(bucket))
  add(path_579183, "object", newJString(`object`))
  add(query_579184, "fields", newJString(fields))
  result = call_579182.call(path_579183, query_579184, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_579169(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_579170, base: "/storage/v1beta1",
    url: url_StorageObjectsDelete_579171, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_579220 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsInsert_579222(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsInsert_579221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579223 = path.getOrDefault("bucket")
  valid_579223 = validateParameter(valid_579223, JString, required = true,
                                 default = nil)
  if valid_579223 != nil:
    section.add "bucket", valid_579223
  var valid_579224 = path.getOrDefault("object")
  valid_579224 = validateParameter(valid_579224, JString, required = true,
                                 default = nil)
  if valid_579224 != nil:
    section.add "object", valid_579224
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579225 = query.getOrDefault("key")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "key", valid_579225
  var valid_579226 = query.getOrDefault("prettyPrint")
  valid_579226 = validateParameter(valid_579226, JBool, required = false,
                                 default = newJBool(true))
  if valid_579226 != nil:
    section.add "prettyPrint", valid_579226
  var valid_579227 = query.getOrDefault("oauth_token")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "oauth_token", valid_579227
  var valid_579228 = query.getOrDefault("alt")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = newJString("json"))
  if valid_579228 != nil:
    section.add "alt", valid_579228
  var valid_579229 = query.getOrDefault("userIp")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "userIp", valid_579229
  var valid_579230 = query.getOrDefault("quotaUser")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "quotaUser", valid_579230
  var valid_579231 = query.getOrDefault("fields")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "fields", valid_579231
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

proc call*(call_579233: Call_StorageObjectAccessControlsInsert_579220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_579233.validator(path, query, header, formData, body)
  let scheme = call_579233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579233.url(scheme.get, call_579233.host, call_579233.base,
                         call_579233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579233, url, valid)

proc call*(call_579234: Call_StorageObjectAccessControlsInsert_579220;
          bucket: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageObjectAccessControlsInsert
  ## Creates a new ACL entry on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579235 = newJObject()
  var query_579236 = newJObject()
  var body_579237 = newJObject()
  add(query_579236, "key", newJString(key))
  add(query_579236, "prettyPrint", newJBool(prettyPrint))
  add(query_579236, "oauth_token", newJString(oauthToken))
  add(query_579236, "alt", newJString(alt))
  add(query_579236, "userIp", newJString(userIp))
  add(query_579236, "quotaUser", newJString(quotaUser))
  add(path_579235, "bucket", newJString(bucket))
  if body != nil:
    body_579237 = body
  add(path_579235, "object", newJString(`object`))
  add(query_579236, "fields", newJString(fields))
  result = call_579234.call(path_579235, query_579236, nil, nil, body_579237)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_579220(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_579221,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsInsert_579222,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_579204 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsList_579206(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsList_579205(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves ACL entries on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579207 = path.getOrDefault("bucket")
  valid_579207 = validateParameter(valid_579207, JString, required = true,
                                 default = nil)
  if valid_579207 != nil:
    section.add "bucket", valid_579207
  var valid_579208 = path.getOrDefault("object")
  valid_579208 = validateParameter(valid_579208, JString, required = true,
                                 default = nil)
  if valid_579208 != nil:
    section.add "object", valid_579208
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579209 = query.getOrDefault("key")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "key", valid_579209
  var valid_579210 = query.getOrDefault("prettyPrint")
  valid_579210 = validateParameter(valid_579210, JBool, required = false,
                                 default = newJBool(true))
  if valid_579210 != nil:
    section.add "prettyPrint", valid_579210
  var valid_579211 = query.getOrDefault("oauth_token")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "oauth_token", valid_579211
  var valid_579212 = query.getOrDefault("alt")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = newJString("json"))
  if valid_579212 != nil:
    section.add "alt", valid_579212
  var valid_579213 = query.getOrDefault("userIp")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "userIp", valid_579213
  var valid_579214 = query.getOrDefault("quotaUser")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "quotaUser", valid_579214
  var valid_579215 = query.getOrDefault("fields")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "fields", valid_579215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579216: Call_StorageObjectAccessControlsList_579204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_579216.validator(path, query, header, formData, body)
  let scheme = call_579216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579216.url(scheme.get, call_579216.host, call_579216.base,
                         call_579216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579216, url, valid)

proc call*(call_579217: Call_StorageObjectAccessControlsList_579204;
          bucket: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsList
  ## Retrieves ACL entries on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579218 = newJObject()
  var query_579219 = newJObject()
  add(query_579219, "key", newJString(key))
  add(query_579219, "prettyPrint", newJBool(prettyPrint))
  add(query_579219, "oauth_token", newJString(oauthToken))
  add(query_579219, "alt", newJString(alt))
  add(query_579219, "userIp", newJString(userIp))
  add(query_579219, "quotaUser", newJString(quotaUser))
  add(path_579218, "bucket", newJString(bucket))
  add(path_579218, "object", newJString(`object`))
  add(query_579219, "fields", newJString(fields))
  result = call_579217.call(path_579218, query_579219, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_579204(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_579205,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsList_579206,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_579255 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsUpdate_579257(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsUpdate_579256(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579258 = path.getOrDefault("bucket")
  valid_579258 = validateParameter(valid_579258, JString, required = true,
                                 default = nil)
  if valid_579258 != nil:
    section.add "bucket", valid_579258
  var valid_579259 = path.getOrDefault("entity")
  valid_579259 = validateParameter(valid_579259, JString, required = true,
                                 default = nil)
  if valid_579259 != nil:
    section.add "entity", valid_579259
  var valid_579260 = path.getOrDefault("object")
  valid_579260 = validateParameter(valid_579260, JString, required = true,
                                 default = nil)
  if valid_579260 != nil:
    section.add "object", valid_579260
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579261 = query.getOrDefault("key")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "key", valid_579261
  var valid_579262 = query.getOrDefault("prettyPrint")
  valid_579262 = validateParameter(valid_579262, JBool, required = false,
                                 default = newJBool(true))
  if valid_579262 != nil:
    section.add "prettyPrint", valid_579262
  var valid_579263 = query.getOrDefault("oauth_token")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "oauth_token", valid_579263
  var valid_579264 = query.getOrDefault("alt")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = newJString("json"))
  if valid_579264 != nil:
    section.add "alt", valid_579264
  var valid_579265 = query.getOrDefault("userIp")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "userIp", valid_579265
  var valid_579266 = query.getOrDefault("quotaUser")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "quotaUser", valid_579266
  var valid_579267 = query.getOrDefault("fields")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "fields", valid_579267
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

proc call*(call_579269: Call_StorageObjectAccessControlsUpdate_579255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_579269.validator(path, query, header, formData, body)
  let scheme = call_579269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579269.url(scheme.get, call_579269.host, call_579269.base,
                         call_579269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579269, url, valid)

proc call*(call_579270: Call_StorageObjectAccessControlsUpdate_579255;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## storageObjectAccessControlsUpdate
  ## Updates an ACL entry on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579271 = newJObject()
  var query_579272 = newJObject()
  var body_579273 = newJObject()
  add(query_579272, "key", newJString(key))
  add(query_579272, "prettyPrint", newJBool(prettyPrint))
  add(query_579272, "oauth_token", newJString(oauthToken))
  add(query_579272, "alt", newJString(alt))
  add(query_579272, "userIp", newJString(userIp))
  add(query_579272, "quotaUser", newJString(quotaUser))
  add(path_579271, "bucket", newJString(bucket))
  if body != nil:
    body_579273 = body
  add(path_579271, "entity", newJString(entity))
  add(path_579271, "object", newJString(`object`))
  add(query_579272, "fields", newJString(fields))
  result = call_579270.call(path_579271, query_579272, nil, nil, body_579273)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_579255(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_579256,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsUpdate_579257,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_579238 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsGet_579240(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsGet_579239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579241 = path.getOrDefault("bucket")
  valid_579241 = validateParameter(valid_579241, JString, required = true,
                                 default = nil)
  if valid_579241 != nil:
    section.add "bucket", valid_579241
  var valid_579242 = path.getOrDefault("entity")
  valid_579242 = validateParameter(valid_579242, JString, required = true,
                                 default = nil)
  if valid_579242 != nil:
    section.add "entity", valid_579242
  var valid_579243 = path.getOrDefault("object")
  valid_579243 = validateParameter(valid_579243, JString, required = true,
                                 default = nil)
  if valid_579243 != nil:
    section.add "object", valid_579243
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579244 = query.getOrDefault("key")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "key", valid_579244
  var valid_579245 = query.getOrDefault("prettyPrint")
  valid_579245 = validateParameter(valid_579245, JBool, required = false,
                                 default = newJBool(true))
  if valid_579245 != nil:
    section.add "prettyPrint", valid_579245
  var valid_579246 = query.getOrDefault("oauth_token")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "oauth_token", valid_579246
  var valid_579247 = query.getOrDefault("alt")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = newJString("json"))
  if valid_579247 != nil:
    section.add "alt", valid_579247
  var valid_579248 = query.getOrDefault("userIp")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "userIp", valid_579248
  var valid_579249 = query.getOrDefault("quotaUser")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "quotaUser", valid_579249
  var valid_579250 = query.getOrDefault("fields")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "fields", valid_579250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579251: Call_StorageObjectAccessControlsGet_579238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_579251.validator(path, query, header, formData, body)
  let scheme = call_579251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579251.url(scheme.get, call_579251.host, call_579251.base,
                         call_579251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579251, url, valid)

proc call*(call_579252: Call_StorageObjectAccessControlsGet_579238; bucket: string;
          entity: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579253 = newJObject()
  var query_579254 = newJObject()
  add(query_579254, "key", newJString(key))
  add(query_579254, "prettyPrint", newJBool(prettyPrint))
  add(query_579254, "oauth_token", newJString(oauthToken))
  add(query_579254, "alt", newJString(alt))
  add(query_579254, "userIp", newJString(userIp))
  add(query_579254, "quotaUser", newJString(quotaUser))
  add(path_579253, "bucket", newJString(bucket))
  add(path_579253, "entity", newJString(entity))
  add(path_579253, "object", newJString(`object`))
  add(query_579254, "fields", newJString(fields))
  result = call_579252.call(path_579253, query_579254, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_579238(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_579239,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsGet_579240,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_579291 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsPatch_579293(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsPatch_579292(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579294 = path.getOrDefault("bucket")
  valid_579294 = validateParameter(valid_579294, JString, required = true,
                                 default = nil)
  if valid_579294 != nil:
    section.add "bucket", valid_579294
  var valid_579295 = path.getOrDefault("entity")
  valid_579295 = validateParameter(valid_579295, JString, required = true,
                                 default = nil)
  if valid_579295 != nil:
    section.add "entity", valid_579295
  var valid_579296 = path.getOrDefault("object")
  valid_579296 = validateParameter(valid_579296, JString, required = true,
                                 default = nil)
  if valid_579296 != nil:
    section.add "object", valid_579296
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579297 = query.getOrDefault("key")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "key", valid_579297
  var valid_579298 = query.getOrDefault("prettyPrint")
  valid_579298 = validateParameter(valid_579298, JBool, required = false,
                                 default = newJBool(true))
  if valid_579298 != nil:
    section.add "prettyPrint", valid_579298
  var valid_579299 = query.getOrDefault("oauth_token")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "oauth_token", valid_579299
  var valid_579300 = query.getOrDefault("alt")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = newJString("json"))
  if valid_579300 != nil:
    section.add "alt", valid_579300
  var valid_579301 = query.getOrDefault("userIp")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "userIp", valid_579301
  var valid_579302 = query.getOrDefault("quotaUser")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "quotaUser", valid_579302
  var valid_579303 = query.getOrDefault("fields")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "fields", valid_579303
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

proc call*(call_579305: Call_StorageObjectAccessControlsPatch_579291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ## 
  let valid = call_579305.validator(path, query, header, formData, body)
  let scheme = call_579305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579305.url(scheme.get, call_579305.host, call_579305.base,
                         call_579305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579305, url, valid)

proc call*(call_579306: Call_StorageObjectAccessControlsPatch_579291;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## storageObjectAccessControlsPatch
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579307 = newJObject()
  var query_579308 = newJObject()
  var body_579309 = newJObject()
  add(query_579308, "key", newJString(key))
  add(query_579308, "prettyPrint", newJBool(prettyPrint))
  add(query_579308, "oauth_token", newJString(oauthToken))
  add(query_579308, "alt", newJString(alt))
  add(query_579308, "userIp", newJString(userIp))
  add(query_579308, "quotaUser", newJString(quotaUser))
  add(path_579307, "bucket", newJString(bucket))
  if body != nil:
    body_579309 = body
  add(path_579307, "entity", newJString(entity))
  add(path_579307, "object", newJString(`object`))
  add(query_579308, "fields", newJString(fields))
  result = call_579306.call(path_579307, query_579308, nil, nil, body_579309)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_579291(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_579292,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsPatch_579293,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_579274 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsDelete_579276(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsDelete_579275(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the ACL entry for the specified entity on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579277 = path.getOrDefault("bucket")
  valid_579277 = validateParameter(valid_579277, JString, required = true,
                                 default = nil)
  if valid_579277 != nil:
    section.add "bucket", valid_579277
  var valid_579278 = path.getOrDefault("entity")
  valid_579278 = validateParameter(valid_579278, JString, required = true,
                                 default = nil)
  if valid_579278 != nil:
    section.add "entity", valid_579278
  var valid_579279 = path.getOrDefault("object")
  valid_579279 = validateParameter(valid_579279, JString, required = true,
                                 default = nil)
  if valid_579279 != nil:
    section.add "object", valid_579279
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579280 = query.getOrDefault("key")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "key", valid_579280
  var valid_579281 = query.getOrDefault("prettyPrint")
  valid_579281 = validateParameter(valid_579281, JBool, required = false,
                                 default = newJBool(true))
  if valid_579281 != nil:
    section.add "prettyPrint", valid_579281
  var valid_579282 = query.getOrDefault("oauth_token")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "oauth_token", valid_579282
  var valid_579283 = query.getOrDefault("alt")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = newJString("json"))
  if valid_579283 != nil:
    section.add "alt", valid_579283
  var valid_579284 = query.getOrDefault("userIp")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "userIp", valid_579284
  var valid_579285 = query.getOrDefault("quotaUser")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "quotaUser", valid_579285
  var valid_579286 = query.getOrDefault("fields")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "fields", valid_579286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579287: Call_StorageObjectAccessControlsDelete_579274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_579287.validator(path, query, header, formData, body)
  let scheme = call_579287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579287.url(scheme.get, call_579287.host, call_579287.base,
                         call_579287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579287, url, valid)

proc call*(call_579288: Call_StorageObjectAccessControlsDelete_579274;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsDelete
  ## Deletes the ACL entry for the specified entity on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579289 = newJObject()
  var query_579290 = newJObject()
  add(query_579290, "key", newJString(key))
  add(query_579290, "prettyPrint", newJBool(prettyPrint))
  add(query_579290, "oauth_token", newJString(oauthToken))
  add(query_579290, "alt", newJString(alt))
  add(query_579290, "userIp", newJString(userIp))
  add(query_579290, "quotaUser", newJString(quotaUser))
  add(path_579289, "bucket", newJString(bucket))
  add(path_579289, "entity", newJString(entity))
  add(path_579289, "object", newJString(`object`))
  add(query_579290, "fields", newJString(fields))
  result = call_579288.call(path_579289, query_579290, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_579274(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_579275,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsDelete_579276,
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
