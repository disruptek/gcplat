
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Storage
## version: v1beta2
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
  ##   project: JString (required)
  ##          : A valid API project identifier.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
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
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_578906 = query.getOrDefault("project")
  valid_578906 = validateParameter(valid_578906, JString, required = true,
                                 default = nil)
  if valid_578906 != nil:
    section.add "project", valid_578906
  var valid_578907 = query.getOrDefault("projection")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = newJString("full"))
  if valid_578907 != nil:
    section.add "projection", valid_578907
  var valid_578908 = query.getOrDefault("fields")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "fields", valid_578908
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

proc call*(call_578910: Call_StorageBucketsInsert_578897; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_578910.validator(path, query, header, formData, body)
  let scheme = call_578910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578910.url(scheme.get, call_578910.host, call_578910.base,
                         call_578910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578910, url, valid)

proc call*(call_578911: Call_StorageBucketsInsert_578897; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; projection: string = "full"; fields: string = ""): Recallable =
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
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   body: JObject
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578912 = newJObject()
  var body_578913 = newJObject()
  add(query_578912, "key", newJString(key))
  add(query_578912, "prettyPrint", newJBool(prettyPrint))
  add(query_578912, "oauth_token", newJString(oauthToken))
  add(query_578912, "alt", newJString(alt))
  add(query_578912, "userIp", newJString(userIp))
  add(query_578912, "quotaUser", newJString(quotaUser))
  add(query_578912, "project", newJString(project))
  if body != nil:
    body_578913 = body
  add(query_578912, "projection", newJString(projection))
  add(query_578912, "fields", newJString(fields))
  result = call_578911.call(nil, query_578912, nil, nil, body_578913)

var storageBucketsInsert* = Call_StorageBucketsInsert_578897(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_578898, base: "/storage/v1beta2",
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
  ##   project: JString (required)
  ##          : A valid API project identifier.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of buckets to return.
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
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_578758 = query.getOrDefault("project")
  valid_578758 = validateParameter(valid_578758, JString, required = true,
                                 default = nil)
  if valid_578758 != nil:
    section.add "project", valid_578758
  var valid_578759 = query.getOrDefault("pageToken")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "pageToken", valid_578759
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
  var valid_578762 = query.getOrDefault("maxResults")
  valid_578762 = validateParameter(valid_578762, JInt, required = false, default = nil)
  if valid_578762 != nil:
    section.add "maxResults", valid_578762
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

proc call*(call_578856: Call_StorageBucketsList_578625; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; projection: string = "full"; fields: string = "";
          maxResults: int = 0): Recallable =
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
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of buckets to return.
  var query_578857 = newJObject()
  add(query_578857, "key", newJString(key))
  add(query_578857, "prettyPrint", newJBool(prettyPrint))
  add(query_578857, "oauth_token", newJString(oauthToken))
  add(query_578857, "alt", newJString(alt))
  add(query_578857, "userIp", newJString(userIp))
  add(query_578857, "quotaUser", newJString(quotaUser))
  add(query_578857, "project", newJString(project))
  add(query_578857, "pageToken", newJString(pageToken))
  add(query_578857, "projection", newJString(projection))
  add(query_578857, "fields", newJString(fields))
  add(query_578857, "maxResults", newJInt(maxResults))
  result = call_578856.call(nil, query_578857, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_578625(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsList_578626, base: "/storage/v1beta2",
    url: url_StorageBucketsList_578627, schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_578946 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsUpdate_578948(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsUpdate_578947(path: JsonNode; query: JsonNode;
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
  var valid_578949 = path.getOrDefault("bucket")
  valid_578949 = validateParameter(valid_578949, JString, required = true,
                                 default = nil)
  if valid_578949 != nil:
    section.add "bucket", valid_578949
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
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578950 = query.getOrDefault("key")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "key", valid_578950
  var valid_578951 = query.getOrDefault("prettyPrint")
  valid_578951 = validateParameter(valid_578951, JBool, required = false,
                                 default = newJBool(true))
  if valid_578951 != nil:
    section.add "prettyPrint", valid_578951
  var valid_578952 = query.getOrDefault("oauth_token")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "oauth_token", valid_578952
  var valid_578953 = query.getOrDefault("alt")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = newJString("json"))
  if valid_578953 != nil:
    section.add "alt", valid_578953
  var valid_578954 = query.getOrDefault("userIp")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "userIp", valid_578954
  var valid_578955 = query.getOrDefault("quotaUser")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "quotaUser", valid_578955
  var valid_578956 = query.getOrDefault("ifMetagenerationMatch")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "ifMetagenerationMatch", valid_578956
  var valid_578957 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "ifMetagenerationNotMatch", valid_578957
  var valid_578958 = query.getOrDefault("projection")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("full"))
  if valid_578958 != nil:
    section.add "projection", valid_578958
  var valid_578959 = query.getOrDefault("fields")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "fields", valid_578959
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

proc call*(call_578961: Call_StorageBucketsUpdate_578946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket.
  ## 
  let valid = call_578961.validator(path, query, header, formData, body)
  let scheme = call_578961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578961.url(scheme.get, call_578961.host, call_578961.base,
                         call_578961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578961, url, valid)

proc call*(call_578962: Call_StorageBucketsUpdate_578946; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
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
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578963 = newJObject()
  var query_578964 = newJObject()
  var body_578965 = newJObject()
  add(query_578964, "key", newJString(key))
  add(query_578964, "prettyPrint", newJBool(prettyPrint))
  add(query_578964, "oauth_token", newJString(oauthToken))
  add(query_578964, "alt", newJString(alt))
  add(query_578964, "userIp", newJString(userIp))
  add(query_578964, "quotaUser", newJString(quotaUser))
  add(query_578964, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_578963, "bucket", newJString(bucket))
  if body != nil:
    body_578965 = body
  add(query_578964, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_578964, "projection", newJString(projection))
  add(query_578964, "fields", newJString(fields))
  result = call_578962.call(path_578963, query_578964, nil, nil, body_578965)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_578946(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_578947, base: "/storage/v1beta2",
    url: url_StorageBucketsUpdate_578948, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_578914 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsGet_578916(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsGet_578915(path: JsonNode; query: JsonNode;
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
  var valid_578931 = path.getOrDefault("bucket")
  valid_578931 = validateParameter(valid_578931, JString, required = true,
                                 default = nil)
  if valid_578931 != nil:
    section.add "bucket", valid_578931
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
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578932 = query.getOrDefault("key")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "key", valid_578932
  var valid_578933 = query.getOrDefault("prettyPrint")
  valid_578933 = validateParameter(valid_578933, JBool, required = false,
                                 default = newJBool(true))
  if valid_578933 != nil:
    section.add "prettyPrint", valid_578933
  var valid_578934 = query.getOrDefault("oauth_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "oauth_token", valid_578934
  var valid_578935 = query.getOrDefault("alt")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString("json"))
  if valid_578935 != nil:
    section.add "alt", valid_578935
  var valid_578936 = query.getOrDefault("userIp")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "userIp", valid_578936
  var valid_578937 = query.getOrDefault("quotaUser")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "quotaUser", valid_578937
  var valid_578938 = query.getOrDefault("ifMetagenerationMatch")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "ifMetagenerationMatch", valid_578938
  var valid_578939 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "ifMetagenerationNotMatch", valid_578939
  var valid_578940 = query.getOrDefault("projection")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("full"))
  if valid_578940 != nil:
    section.add "projection", valid_578940
  var valid_578941 = query.getOrDefault("fields")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "fields", valid_578941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578942: Call_StorageBucketsGet_578914; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_578942.validator(path, query, header, formData, body)
  let scheme = call_578942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578942.url(scheme.get, call_578942.host, call_578942.base,
                         call_578942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578942, url, valid)

proc call*(call_578943: Call_StorageBucketsGet_578914; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; ifMetagenerationNotMatch: string = "";
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
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578944 = newJObject()
  var query_578945 = newJObject()
  add(query_578945, "key", newJString(key))
  add(query_578945, "prettyPrint", newJBool(prettyPrint))
  add(query_578945, "oauth_token", newJString(oauthToken))
  add(query_578945, "alt", newJString(alt))
  add(query_578945, "userIp", newJString(userIp))
  add(query_578945, "quotaUser", newJString(quotaUser))
  add(query_578945, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_578944, "bucket", newJString(bucket))
  add(query_578945, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_578945, "projection", newJString(projection))
  add(query_578945, "fields", newJString(fields))
  result = call_578943.call(path_578944, query_578945, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_578914(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_578915, base: "/storage/v1beta2",
    url: url_StorageBucketsGet_578916, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_578983 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsPatch_578985(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsPatch_578984(path: JsonNode; query: JsonNode;
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
  var valid_578986 = path.getOrDefault("bucket")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "bucket", valid_578986
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
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578987 = query.getOrDefault("key")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "key", valid_578987
  var valid_578988 = query.getOrDefault("prettyPrint")
  valid_578988 = validateParameter(valid_578988, JBool, required = false,
                                 default = newJBool(true))
  if valid_578988 != nil:
    section.add "prettyPrint", valid_578988
  var valid_578989 = query.getOrDefault("oauth_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "oauth_token", valid_578989
  var valid_578990 = query.getOrDefault("alt")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("json"))
  if valid_578990 != nil:
    section.add "alt", valid_578990
  var valid_578991 = query.getOrDefault("userIp")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "userIp", valid_578991
  var valid_578992 = query.getOrDefault("quotaUser")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "quotaUser", valid_578992
  var valid_578993 = query.getOrDefault("ifMetagenerationMatch")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "ifMetagenerationMatch", valid_578993
  var valid_578994 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "ifMetagenerationNotMatch", valid_578994
  var valid_578995 = query.getOrDefault("projection")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("full"))
  if valid_578995 != nil:
    section.add "projection", valid_578995
  var valid_578996 = query.getOrDefault("fields")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "fields", valid_578996
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

proc call*(call_578998: Call_StorageBucketsPatch_578983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. This method supports patch semantics.
  ## 
  let valid = call_578998.validator(path, query, header, formData, body)
  let scheme = call_578998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578998.url(scheme.get, call_578998.host, call_578998.base,
                         call_578998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578998, url, valid)

proc call*(call_578999: Call_StorageBucketsPatch_578983; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
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
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579000 = newJObject()
  var query_579001 = newJObject()
  var body_579002 = newJObject()
  add(query_579001, "key", newJString(key))
  add(query_579001, "prettyPrint", newJBool(prettyPrint))
  add(query_579001, "oauth_token", newJString(oauthToken))
  add(query_579001, "alt", newJString(alt))
  add(query_579001, "userIp", newJString(userIp))
  add(query_579001, "quotaUser", newJString(quotaUser))
  add(query_579001, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579000, "bucket", newJString(bucket))
  if body != nil:
    body_579002 = body
  add(query_579001, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579001, "projection", newJString(projection))
  add(query_579001, "fields", newJString(fields))
  result = call_578999.call(path_579000, query_579001, nil, nil, body_579002)

var storageBucketsPatch* = Call_StorageBucketsPatch_578983(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_578984, base: "/storage/v1beta2",
    url: url_StorageBucketsPatch_578985, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_578966 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsDelete_578968(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsDelete_578967(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes an empty bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_578969 = path.getOrDefault("bucket")
  valid_578969 = validateParameter(valid_578969, JString, required = true,
                                 default = nil)
  if valid_578969 != nil:
    section.add "bucket", valid_578969
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
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578970 = query.getOrDefault("key")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "key", valid_578970
  var valid_578971 = query.getOrDefault("prettyPrint")
  valid_578971 = validateParameter(valid_578971, JBool, required = false,
                                 default = newJBool(true))
  if valid_578971 != nil:
    section.add "prettyPrint", valid_578971
  var valid_578972 = query.getOrDefault("oauth_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "oauth_token", valid_578972
  var valid_578973 = query.getOrDefault("alt")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = newJString("json"))
  if valid_578973 != nil:
    section.add "alt", valid_578973
  var valid_578974 = query.getOrDefault("userIp")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "userIp", valid_578974
  var valid_578975 = query.getOrDefault("quotaUser")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "quotaUser", valid_578975
  var valid_578976 = query.getOrDefault("ifMetagenerationMatch")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "ifMetagenerationMatch", valid_578976
  var valid_578977 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "ifMetagenerationNotMatch", valid_578977
  var valid_578978 = query.getOrDefault("fields")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "fields", valid_578978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578979: Call_StorageBucketsDelete_578966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes an empty bucket.
  ## 
  let valid = call_578979.validator(path, query, header, formData, body)
  let scheme = call_578979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578979.url(scheme.get, call_578979.host, call_578979.base,
                         call_578979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578979, url, valid)

proc call*(call_578980: Call_StorageBucketsDelete_578966; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; ifMetagenerationNotMatch: string = "";
          fields: string = ""): Recallable =
  ## storageBucketsDelete
  ## Permanently deletes an empty bucket.
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
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578981 = newJObject()
  var query_578982 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "userIp", newJString(userIp))
  add(query_578982, "quotaUser", newJString(quotaUser))
  add(query_578982, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_578981, "bucket", newJString(bucket))
  add(query_578982, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_578982, "fields", newJString(fields))
  result = call_578980.call(path_578981, query_578982, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_578966(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_578967, base: "/storage/v1beta2",
    url: url_StorageBucketsDelete_578968, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_579018 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsInsert_579020(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsInsert_579019(path: JsonNode;
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
  var valid_579021 = path.getOrDefault("bucket")
  valid_579021 = validateParameter(valid_579021, JString, required = true,
                                 default = nil)
  if valid_579021 != nil:
    section.add "bucket", valid_579021
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
  var valid_579022 = query.getOrDefault("key")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "key", valid_579022
  var valid_579023 = query.getOrDefault("prettyPrint")
  valid_579023 = validateParameter(valid_579023, JBool, required = false,
                                 default = newJBool(true))
  if valid_579023 != nil:
    section.add "prettyPrint", valid_579023
  var valid_579024 = query.getOrDefault("oauth_token")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "oauth_token", valid_579024
  var valid_579025 = query.getOrDefault("alt")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = newJString("json"))
  if valid_579025 != nil:
    section.add "alt", valid_579025
  var valid_579026 = query.getOrDefault("userIp")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "userIp", valid_579026
  var valid_579027 = query.getOrDefault("quotaUser")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "quotaUser", valid_579027
  var valid_579028 = query.getOrDefault("fields")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "fields", valid_579028
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

proc call*(call_579030: Call_StorageBucketAccessControlsInsert_579018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_579030.validator(path, query, header, formData, body)
  let scheme = call_579030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579030.url(scheme.get, call_579030.host, call_579030.base,
                         call_579030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579030, url, valid)

proc call*(call_579031: Call_StorageBucketAccessControlsInsert_579018;
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
  var path_579032 = newJObject()
  var query_579033 = newJObject()
  var body_579034 = newJObject()
  add(query_579033, "key", newJString(key))
  add(query_579033, "prettyPrint", newJBool(prettyPrint))
  add(query_579033, "oauth_token", newJString(oauthToken))
  add(query_579033, "alt", newJString(alt))
  add(query_579033, "userIp", newJString(userIp))
  add(query_579033, "quotaUser", newJString(quotaUser))
  add(path_579032, "bucket", newJString(bucket))
  if body != nil:
    body_579034 = body
  add(query_579033, "fields", newJString(fields))
  result = call_579031.call(path_579032, query_579033, nil, nil, body_579034)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_579018(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_579019,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsInsert_579020,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_579003 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsList_579005(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsList_579004(path: JsonNode;
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
  var valid_579006 = path.getOrDefault("bucket")
  valid_579006 = validateParameter(valid_579006, JString, required = true,
                                 default = nil)
  if valid_579006 != nil:
    section.add "bucket", valid_579006
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
  var valid_579007 = query.getOrDefault("key")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "key", valid_579007
  var valid_579008 = query.getOrDefault("prettyPrint")
  valid_579008 = validateParameter(valid_579008, JBool, required = false,
                                 default = newJBool(true))
  if valid_579008 != nil:
    section.add "prettyPrint", valid_579008
  var valid_579009 = query.getOrDefault("oauth_token")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "oauth_token", valid_579009
  var valid_579010 = query.getOrDefault("alt")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = newJString("json"))
  if valid_579010 != nil:
    section.add "alt", valid_579010
  var valid_579011 = query.getOrDefault("userIp")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "userIp", valid_579011
  var valid_579012 = query.getOrDefault("quotaUser")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "quotaUser", valid_579012
  var valid_579013 = query.getOrDefault("fields")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "fields", valid_579013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579014: Call_StorageBucketAccessControlsList_579003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_579014.validator(path, query, header, formData, body)
  let scheme = call_579014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579014.url(scheme.get, call_579014.host, call_579014.base,
                         call_579014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579014, url, valid)

proc call*(call_579015: Call_StorageBucketAccessControlsList_579003;
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
  var path_579016 = newJObject()
  var query_579017 = newJObject()
  add(query_579017, "key", newJString(key))
  add(query_579017, "prettyPrint", newJBool(prettyPrint))
  add(query_579017, "oauth_token", newJString(oauthToken))
  add(query_579017, "alt", newJString(alt))
  add(query_579017, "userIp", newJString(userIp))
  add(query_579017, "quotaUser", newJString(quotaUser))
  add(path_579016, "bucket", newJString(bucket))
  add(query_579017, "fields", newJString(fields))
  result = call_579015.call(path_579016, query_579017, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_579003(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_579004,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsList_579005,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_579051 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsUpdate_579053(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsUpdate_579052(path: JsonNode;
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
  var valid_579054 = path.getOrDefault("bucket")
  valid_579054 = validateParameter(valid_579054, JString, required = true,
                                 default = nil)
  if valid_579054 != nil:
    section.add "bucket", valid_579054
  var valid_579055 = path.getOrDefault("entity")
  valid_579055 = validateParameter(valid_579055, JString, required = true,
                                 default = nil)
  if valid_579055 != nil:
    section.add "entity", valid_579055
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
  var valid_579056 = query.getOrDefault("key")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "key", valid_579056
  var valid_579057 = query.getOrDefault("prettyPrint")
  valid_579057 = validateParameter(valid_579057, JBool, required = false,
                                 default = newJBool(true))
  if valid_579057 != nil:
    section.add "prettyPrint", valid_579057
  var valid_579058 = query.getOrDefault("oauth_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "oauth_token", valid_579058
  var valid_579059 = query.getOrDefault("alt")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("json"))
  if valid_579059 != nil:
    section.add "alt", valid_579059
  var valid_579060 = query.getOrDefault("userIp")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "userIp", valid_579060
  var valid_579061 = query.getOrDefault("quotaUser")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "quotaUser", valid_579061
  var valid_579062 = query.getOrDefault("fields")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "fields", valid_579062
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

proc call*(call_579064: Call_StorageBucketAccessControlsUpdate_579051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_579064.validator(path, query, header, formData, body)
  let scheme = call_579064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579064.url(scheme.get, call_579064.host, call_579064.base,
                         call_579064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579064, url, valid)

proc call*(call_579065: Call_StorageBucketAccessControlsUpdate_579051;
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
  var path_579066 = newJObject()
  var query_579067 = newJObject()
  var body_579068 = newJObject()
  add(query_579067, "key", newJString(key))
  add(query_579067, "prettyPrint", newJBool(prettyPrint))
  add(query_579067, "oauth_token", newJString(oauthToken))
  add(query_579067, "alt", newJString(alt))
  add(query_579067, "userIp", newJString(userIp))
  add(query_579067, "quotaUser", newJString(quotaUser))
  add(path_579066, "bucket", newJString(bucket))
  if body != nil:
    body_579068 = body
  add(path_579066, "entity", newJString(entity))
  add(query_579067, "fields", newJString(fields))
  result = call_579065.call(path_579066, query_579067, nil, nil, body_579068)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_579051(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_579052,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsUpdate_579053,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_579035 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsGet_579037(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsGet_579036(path: JsonNode;
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
  var valid_579038 = path.getOrDefault("bucket")
  valid_579038 = validateParameter(valid_579038, JString, required = true,
                                 default = nil)
  if valid_579038 != nil:
    section.add "bucket", valid_579038
  var valid_579039 = path.getOrDefault("entity")
  valid_579039 = validateParameter(valid_579039, JString, required = true,
                                 default = nil)
  if valid_579039 != nil:
    section.add "entity", valid_579039
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
  var valid_579040 = query.getOrDefault("key")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "key", valid_579040
  var valid_579041 = query.getOrDefault("prettyPrint")
  valid_579041 = validateParameter(valid_579041, JBool, required = false,
                                 default = newJBool(true))
  if valid_579041 != nil:
    section.add "prettyPrint", valid_579041
  var valid_579042 = query.getOrDefault("oauth_token")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "oauth_token", valid_579042
  var valid_579043 = query.getOrDefault("alt")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = newJString("json"))
  if valid_579043 != nil:
    section.add "alt", valid_579043
  var valid_579044 = query.getOrDefault("userIp")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "userIp", valid_579044
  var valid_579045 = query.getOrDefault("quotaUser")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "quotaUser", valid_579045
  var valid_579046 = query.getOrDefault("fields")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "fields", valid_579046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579047: Call_StorageBucketAccessControlsGet_579035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_579047.validator(path, query, header, formData, body)
  let scheme = call_579047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579047.url(scheme.get, call_579047.host, call_579047.base,
                         call_579047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579047, url, valid)

proc call*(call_579048: Call_StorageBucketAccessControlsGet_579035; bucket: string;
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
  var path_579049 = newJObject()
  var query_579050 = newJObject()
  add(query_579050, "key", newJString(key))
  add(query_579050, "prettyPrint", newJBool(prettyPrint))
  add(query_579050, "oauth_token", newJString(oauthToken))
  add(query_579050, "alt", newJString(alt))
  add(query_579050, "userIp", newJString(userIp))
  add(query_579050, "quotaUser", newJString(quotaUser))
  add(path_579049, "bucket", newJString(bucket))
  add(path_579049, "entity", newJString(entity))
  add(query_579050, "fields", newJString(fields))
  result = call_579048.call(path_579049, query_579050, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_579035(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_579036,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsGet_579037,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_579085 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsPatch_579087(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsPatch_579086(path: JsonNode;
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
  var valid_579088 = path.getOrDefault("bucket")
  valid_579088 = validateParameter(valid_579088, JString, required = true,
                                 default = nil)
  if valid_579088 != nil:
    section.add "bucket", valid_579088
  var valid_579089 = path.getOrDefault("entity")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = nil)
  if valid_579089 != nil:
    section.add "entity", valid_579089
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
  var valid_579090 = query.getOrDefault("key")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "key", valid_579090
  var valid_579091 = query.getOrDefault("prettyPrint")
  valid_579091 = validateParameter(valid_579091, JBool, required = false,
                                 default = newJBool(true))
  if valid_579091 != nil:
    section.add "prettyPrint", valid_579091
  var valid_579092 = query.getOrDefault("oauth_token")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "oauth_token", valid_579092
  var valid_579093 = query.getOrDefault("alt")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = newJString("json"))
  if valid_579093 != nil:
    section.add "alt", valid_579093
  var valid_579094 = query.getOrDefault("userIp")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "userIp", valid_579094
  var valid_579095 = query.getOrDefault("quotaUser")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "quotaUser", valid_579095
  var valid_579096 = query.getOrDefault("fields")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "fields", valid_579096
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

proc call*(call_579098: Call_StorageBucketAccessControlsPatch_579085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  let valid = call_579098.validator(path, query, header, formData, body)
  let scheme = call_579098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579098.url(scheme.get, call_579098.host, call_579098.base,
                         call_579098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579098, url, valid)

proc call*(call_579099: Call_StorageBucketAccessControlsPatch_579085;
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
  var path_579100 = newJObject()
  var query_579101 = newJObject()
  var body_579102 = newJObject()
  add(query_579101, "key", newJString(key))
  add(query_579101, "prettyPrint", newJBool(prettyPrint))
  add(query_579101, "oauth_token", newJString(oauthToken))
  add(query_579101, "alt", newJString(alt))
  add(query_579101, "userIp", newJString(userIp))
  add(query_579101, "quotaUser", newJString(quotaUser))
  add(path_579100, "bucket", newJString(bucket))
  if body != nil:
    body_579102 = body
  add(path_579100, "entity", newJString(entity))
  add(query_579101, "fields", newJString(fields))
  result = call_579099.call(path_579100, query_579101, nil, nil, body_579102)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_579085(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_579086,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsPatch_579087,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_579069 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsDelete_579071(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsDelete_579070(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
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
  var valid_579072 = path.getOrDefault("bucket")
  valid_579072 = validateParameter(valid_579072, JString, required = true,
                                 default = nil)
  if valid_579072 != nil:
    section.add "bucket", valid_579072
  var valid_579073 = path.getOrDefault("entity")
  valid_579073 = validateParameter(valid_579073, JString, required = true,
                                 default = nil)
  if valid_579073 != nil:
    section.add "entity", valid_579073
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
  var valid_579074 = query.getOrDefault("key")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "key", valid_579074
  var valid_579075 = query.getOrDefault("prettyPrint")
  valid_579075 = validateParameter(valid_579075, JBool, required = false,
                                 default = newJBool(true))
  if valid_579075 != nil:
    section.add "prettyPrint", valid_579075
  var valid_579076 = query.getOrDefault("oauth_token")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "oauth_token", valid_579076
  var valid_579077 = query.getOrDefault("alt")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = newJString("json"))
  if valid_579077 != nil:
    section.add "alt", valid_579077
  var valid_579078 = query.getOrDefault("userIp")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "userIp", valid_579078
  var valid_579079 = query.getOrDefault("quotaUser")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "quotaUser", valid_579079
  var valid_579080 = query.getOrDefault("fields")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "fields", valid_579080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579081: Call_StorageBucketAccessControlsDelete_579069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_579081.validator(path, query, header, formData, body)
  let scheme = call_579081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579081.url(scheme.get, call_579081.host, call_579081.base,
                         call_579081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579081, url, valid)

proc call*(call_579082: Call_StorageBucketAccessControlsDelete_579069;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsDelete
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
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
  var path_579083 = newJObject()
  var query_579084 = newJObject()
  add(query_579084, "key", newJString(key))
  add(query_579084, "prettyPrint", newJBool(prettyPrint))
  add(query_579084, "oauth_token", newJString(oauthToken))
  add(query_579084, "alt", newJString(alt))
  add(query_579084, "userIp", newJString(userIp))
  add(query_579084, "quotaUser", newJString(quotaUser))
  add(path_579083, "bucket", newJString(bucket))
  add(path_579083, "entity", newJString(entity))
  add(query_579084, "fields", newJString(fields))
  result = call_579082.call(path_579083, query_579084, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_579069(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_579070,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsDelete_579071,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsInsert_579120 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsInsert_579122(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsInsert_579121(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579123 = path.getOrDefault("bucket")
  valid_579123 = validateParameter(valid_579123, JString, required = true,
                                 default = nil)
  if valid_579123 != nil:
    section.add "bucket", valid_579123
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
  var valid_579124 = query.getOrDefault("key")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "key", valid_579124
  var valid_579125 = query.getOrDefault("prettyPrint")
  valid_579125 = validateParameter(valid_579125, JBool, required = false,
                                 default = newJBool(true))
  if valid_579125 != nil:
    section.add "prettyPrint", valid_579125
  var valid_579126 = query.getOrDefault("oauth_token")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "oauth_token", valid_579126
  var valid_579127 = query.getOrDefault("alt")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = newJString("json"))
  if valid_579127 != nil:
    section.add "alt", valid_579127
  var valid_579128 = query.getOrDefault("userIp")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "userIp", valid_579128
  var valid_579129 = query.getOrDefault("quotaUser")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "quotaUser", valid_579129
  var valid_579130 = query.getOrDefault("fields")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "fields", valid_579130
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

proc call*(call_579132: Call_StorageDefaultObjectAccessControlsInsert_579120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  let valid = call_579132.validator(path, query, header, formData, body)
  let scheme = call_579132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579132.url(scheme.get, call_579132.host, call_579132.base,
                         call_579132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579132, url, valid)

proc call*(call_579133: Call_StorageDefaultObjectAccessControlsInsert_579120;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsInsert
  ## Creates a new default object ACL entry on the specified bucket.
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
  var path_579134 = newJObject()
  var query_579135 = newJObject()
  var body_579136 = newJObject()
  add(query_579135, "key", newJString(key))
  add(query_579135, "prettyPrint", newJBool(prettyPrint))
  add(query_579135, "oauth_token", newJString(oauthToken))
  add(query_579135, "alt", newJString(alt))
  add(query_579135, "userIp", newJString(userIp))
  add(query_579135, "quotaUser", newJString(quotaUser))
  add(path_579134, "bucket", newJString(bucket))
  if body != nil:
    body_579136 = body
  add(query_579135, "fields", newJString(fields))
  result = call_579133.call(path_579134, query_579135, nil, nil, body_579136)

var storageDefaultObjectAccessControlsInsert* = Call_StorageDefaultObjectAccessControlsInsert_579120(
    name: "storageDefaultObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsInsert_579121,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsInsert_579122,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsList_579103 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsList_579105(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsList_579104(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579106 = path.getOrDefault("bucket")
  valid_579106 = validateParameter(valid_579106, JString, required = true,
                                 default = nil)
  if valid_579106 != nil:
    section.add "bucket", valid_579106
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
  ##   ifMetagenerationMatch: JString
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579107 = query.getOrDefault("key")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "key", valid_579107
  var valid_579108 = query.getOrDefault("prettyPrint")
  valid_579108 = validateParameter(valid_579108, JBool, required = false,
                                 default = newJBool(true))
  if valid_579108 != nil:
    section.add "prettyPrint", valid_579108
  var valid_579109 = query.getOrDefault("oauth_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "oauth_token", valid_579109
  var valid_579110 = query.getOrDefault("alt")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = newJString("json"))
  if valid_579110 != nil:
    section.add "alt", valid_579110
  var valid_579111 = query.getOrDefault("userIp")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "userIp", valid_579111
  var valid_579112 = query.getOrDefault("quotaUser")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "quotaUser", valid_579112
  var valid_579113 = query.getOrDefault("ifMetagenerationMatch")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "ifMetagenerationMatch", valid_579113
  var valid_579114 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "ifMetagenerationNotMatch", valid_579114
  var valid_579115 = query.getOrDefault("fields")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "fields", valid_579115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579116: Call_StorageDefaultObjectAccessControlsList_579103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  let valid = call_579116.validator(path, query, header, formData, body)
  let scheme = call_579116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579116.url(scheme.get, call_579116.host, call_579116.base,
                         call_579116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579116, url, valid)

proc call*(call_579117: Call_StorageDefaultObjectAccessControlsList_579103;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; ifMetagenerationMatch: string = "";
          ifMetagenerationNotMatch: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsList
  ## Retrieves default object ACL entries on the specified bucket.
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
  ##   ifMetagenerationMatch: string
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579118 = newJObject()
  var query_579119 = newJObject()
  add(query_579119, "key", newJString(key))
  add(query_579119, "prettyPrint", newJBool(prettyPrint))
  add(query_579119, "oauth_token", newJString(oauthToken))
  add(query_579119, "alt", newJString(alt))
  add(query_579119, "userIp", newJString(userIp))
  add(query_579119, "quotaUser", newJString(quotaUser))
  add(query_579119, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579118, "bucket", newJString(bucket))
  add(query_579119, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579119, "fields", newJString(fields))
  result = call_579117.call(path_579118, query_579119, nil, nil, nil)

var storageDefaultObjectAccessControlsList* = Call_StorageDefaultObjectAccessControlsList_579103(
    name: "storageDefaultObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsList_579104,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsList_579105,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsUpdate_579153 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsUpdate_579155(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsUpdate_579154(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a default object ACL entry on the specified bucket.
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
  var valid_579156 = path.getOrDefault("bucket")
  valid_579156 = validateParameter(valid_579156, JString, required = true,
                                 default = nil)
  if valid_579156 != nil:
    section.add "bucket", valid_579156
  var valid_579157 = path.getOrDefault("entity")
  valid_579157 = validateParameter(valid_579157, JString, required = true,
                                 default = nil)
  if valid_579157 != nil:
    section.add "entity", valid_579157
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
  var valid_579158 = query.getOrDefault("key")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "key", valid_579158
  var valid_579159 = query.getOrDefault("prettyPrint")
  valid_579159 = validateParameter(valid_579159, JBool, required = false,
                                 default = newJBool(true))
  if valid_579159 != nil:
    section.add "prettyPrint", valid_579159
  var valid_579160 = query.getOrDefault("oauth_token")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "oauth_token", valid_579160
  var valid_579161 = query.getOrDefault("alt")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("json"))
  if valid_579161 != nil:
    section.add "alt", valid_579161
  var valid_579162 = query.getOrDefault("userIp")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "userIp", valid_579162
  var valid_579163 = query.getOrDefault("quotaUser")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "quotaUser", valid_579163
  var valid_579164 = query.getOrDefault("fields")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "fields", valid_579164
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

proc call*(call_579166: Call_StorageDefaultObjectAccessControlsUpdate_579153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket.
  ## 
  let valid = call_579166.validator(path, query, header, formData, body)
  let scheme = call_579166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579166.url(scheme.get, call_579166.host, call_579166.base,
                         call_579166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579166, url, valid)

proc call*(call_579167: Call_StorageDefaultObjectAccessControlsUpdate_579153;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsUpdate
  ## Updates a default object ACL entry on the specified bucket.
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
  var path_579168 = newJObject()
  var query_579169 = newJObject()
  var body_579170 = newJObject()
  add(query_579169, "key", newJString(key))
  add(query_579169, "prettyPrint", newJBool(prettyPrint))
  add(query_579169, "oauth_token", newJString(oauthToken))
  add(query_579169, "alt", newJString(alt))
  add(query_579169, "userIp", newJString(userIp))
  add(query_579169, "quotaUser", newJString(quotaUser))
  add(path_579168, "bucket", newJString(bucket))
  if body != nil:
    body_579170 = body
  add(path_579168, "entity", newJString(entity))
  add(query_579169, "fields", newJString(fields))
  result = call_579167.call(path_579168, query_579169, nil, nil, body_579170)

var storageDefaultObjectAccessControlsUpdate* = Call_StorageDefaultObjectAccessControlsUpdate_579153(
    name: "storageDefaultObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsUpdate_579154,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsUpdate_579155,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsGet_579137 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsGet_579139(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsGet_579138(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
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
  var valid_579140 = path.getOrDefault("bucket")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "bucket", valid_579140
  var valid_579141 = path.getOrDefault("entity")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "entity", valid_579141
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
  var valid_579142 = query.getOrDefault("key")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "key", valid_579142
  var valid_579143 = query.getOrDefault("prettyPrint")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(true))
  if valid_579143 != nil:
    section.add "prettyPrint", valid_579143
  var valid_579144 = query.getOrDefault("oauth_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "oauth_token", valid_579144
  var valid_579145 = query.getOrDefault("alt")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("json"))
  if valid_579145 != nil:
    section.add "alt", valid_579145
  var valid_579146 = query.getOrDefault("userIp")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "userIp", valid_579146
  var valid_579147 = query.getOrDefault("quotaUser")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "quotaUser", valid_579147
  var valid_579148 = query.getOrDefault("fields")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "fields", valid_579148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579149: Call_StorageDefaultObjectAccessControlsGet_579137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_579149.validator(path, query, header, formData, body)
  let scheme = call_579149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579149.url(scheme.get, call_579149.host, call_579149.base,
                         call_579149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579149, url, valid)

proc call*(call_579150: Call_StorageDefaultObjectAccessControlsGet_579137;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsGet
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
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
  var path_579151 = newJObject()
  var query_579152 = newJObject()
  add(query_579152, "key", newJString(key))
  add(query_579152, "prettyPrint", newJBool(prettyPrint))
  add(query_579152, "oauth_token", newJString(oauthToken))
  add(query_579152, "alt", newJString(alt))
  add(query_579152, "userIp", newJString(userIp))
  add(query_579152, "quotaUser", newJString(quotaUser))
  add(path_579151, "bucket", newJString(bucket))
  add(path_579151, "entity", newJString(entity))
  add(query_579152, "fields", newJString(fields))
  result = call_579150.call(path_579151, query_579152, nil, nil, nil)

var storageDefaultObjectAccessControlsGet* = Call_StorageDefaultObjectAccessControlsGet_579137(
    name: "storageDefaultObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsGet_579138,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsGet_579139,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsPatch_579187 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsPatch_579189(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsPatch_579188(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
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
  var valid_579190 = path.getOrDefault("bucket")
  valid_579190 = validateParameter(valid_579190, JString, required = true,
                                 default = nil)
  if valid_579190 != nil:
    section.add "bucket", valid_579190
  var valid_579191 = path.getOrDefault("entity")
  valid_579191 = validateParameter(valid_579191, JString, required = true,
                                 default = nil)
  if valid_579191 != nil:
    section.add "entity", valid_579191
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
  var valid_579192 = query.getOrDefault("key")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "key", valid_579192
  var valid_579193 = query.getOrDefault("prettyPrint")
  valid_579193 = validateParameter(valid_579193, JBool, required = false,
                                 default = newJBool(true))
  if valid_579193 != nil:
    section.add "prettyPrint", valid_579193
  var valid_579194 = query.getOrDefault("oauth_token")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "oauth_token", valid_579194
  var valid_579195 = query.getOrDefault("alt")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = newJString("json"))
  if valid_579195 != nil:
    section.add "alt", valid_579195
  var valid_579196 = query.getOrDefault("userIp")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "userIp", valid_579196
  var valid_579197 = query.getOrDefault("quotaUser")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "quotaUser", valid_579197
  var valid_579198 = query.getOrDefault("fields")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "fields", valid_579198
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

proc call*(call_579200: Call_StorageDefaultObjectAccessControlsPatch_579187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  let valid = call_579200.validator(path, query, header, formData, body)
  let scheme = call_579200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579200.url(scheme.get, call_579200.host, call_579200.base,
                         call_579200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579200, url, valid)

proc call*(call_579201: Call_StorageDefaultObjectAccessControlsPatch_579187;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsPatch
  ## Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
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
  var path_579202 = newJObject()
  var query_579203 = newJObject()
  var body_579204 = newJObject()
  add(query_579203, "key", newJString(key))
  add(query_579203, "prettyPrint", newJBool(prettyPrint))
  add(query_579203, "oauth_token", newJString(oauthToken))
  add(query_579203, "alt", newJString(alt))
  add(query_579203, "userIp", newJString(userIp))
  add(query_579203, "quotaUser", newJString(quotaUser))
  add(path_579202, "bucket", newJString(bucket))
  if body != nil:
    body_579204 = body
  add(path_579202, "entity", newJString(entity))
  add(query_579203, "fields", newJString(fields))
  result = call_579201.call(path_579202, query_579203, nil, nil, body_579204)

var storageDefaultObjectAccessControlsPatch* = Call_StorageDefaultObjectAccessControlsPatch_579187(
    name: "storageDefaultObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsPatch_579188,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsPatch_579189,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsDelete_579171 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsDelete_579173(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsDelete_579172(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
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
  var valid_579174 = path.getOrDefault("bucket")
  valid_579174 = validateParameter(valid_579174, JString, required = true,
                                 default = nil)
  if valid_579174 != nil:
    section.add "bucket", valid_579174
  var valid_579175 = path.getOrDefault("entity")
  valid_579175 = validateParameter(valid_579175, JString, required = true,
                                 default = nil)
  if valid_579175 != nil:
    section.add "entity", valid_579175
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
  var valid_579176 = query.getOrDefault("key")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "key", valid_579176
  var valid_579177 = query.getOrDefault("prettyPrint")
  valid_579177 = validateParameter(valid_579177, JBool, required = false,
                                 default = newJBool(true))
  if valid_579177 != nil:
    section.add "prettyPrint", valid_579177
  var valid_579178 = query.getOrDefault("oauth_token")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "oauth_token", valid_579178
  var valid_579179 = query.getOrDefault("alt")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = newJString("json"))
  if valid_579179 != nil:
    section.add "alt", valid_579179
  var valid_579180 = query.getOrDefault("userIp")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "userIp", valid_579180
  var valid_579181 = query.getOrDefault("quotaUser")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "quotaUser", valid_579181
  var valid_579182 = query.getOrDefault("fields")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "fields", valid_579182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579183: Call_StorageDefaultObjectAccessControlsDelete_579171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_579183.validator(path, query, header, formData, body)
  let scheme = call_579183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579183.url(scheme.get, call_579183.host, call_579183.base,
                         call_579183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579183, url, valid)

proc call*(call_579184: Call_StorageDefaultObjectAccessControlsDelete_579171;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsDelete
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
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
  var path_579185 = newJObject()
  var query_579186 = newJObject()
  add(query_579186, "key", newJString(key))
  add(query_579186, "prettyPrint", newJBool(prettyPrint))
  add(query_579186, "oauth_token", newJString(oauthToken))
  add(query_579186, "alt", newJString(alt))
  add(query_579186, "userIp", newJString(userIp))
  add(query_579186, "quotaUser", newJString(quotaUser))
  add(path_579185, "bucket", newJString(bucket))
  add(path_579185, "entity", newJString(entity))
  add(query_579186, "fields", newJString(fields))
  result = call_579184.call(path_579185, query_579186, nil, nil, nil)

var storageDefaultObjectAccessControlsDelete* = Call_StorageDefaultObjectAccessControlsDelete_579171(
    name: "storageDefaultObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsDelete_579172,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsDelete_579173,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_579226 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsInsert_579228(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsInsert_579227(path: JsonNode; query: JsonNode;
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
  var valid_579229 = path.getOrDefault("bucket")
  valid_579229 = validateParameter(valid_579229, JString, required = true,
                                 default = nil)
  if valid_579229 != nil:
    section.add "bucket", valid_579229
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
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579230 = query.getOrDefault("key")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "key", valid_579230
  var valid_579231 = query.getOrDefault("prettyPrint")
  valid_579231 = validateParameter(valid_579231, JBool, required = false,
                                 default = newJBool(true))
  if valid_579231 != nil:
    section.add "prettyPrint", valid_579231
  var valid_579232 = query.getOrDefault("oauth_token")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "oauth_token", valid_579232
  var valid_579233 = query.getOrDefault("name")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "name", valid_579233
  var valid_579234 = query.getOrDefault("ifGenerationMatch")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "ifGenerationMatch", valid_579234
  var valid_579235 = query.getOrDefault("ifGenerationNotMatch")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "ifGenerationNotMatch", valid_579235
  var valid_579236 = query.getOrDefault("alt")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = newJString("json"))
  if valid_579236 != nil:
    section.add "alt", valid_579236
  var valid_579237 = query.getOrDefault("userIp")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "userIp", valid_579237
  var valid_579238 = query.getOrDefault("quotaUser")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "quotaUser", valid_579238
  var valid_579239 = query.getOrDefault("ifMetagenerationMatch")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "ifMetagenerationMatch", valid_579239
  var valid_579240 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "ifMetagenerationNotMatch", valid_579240
  var valid_579241 = query.getOrDefault("projection")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = newJString("full"))
  if valid_579241 != nil:
    section.add "projection", valid_579241
  var valid_579242 = query.getOrDefault("fields")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "fields", valid_579242
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

proc call*(call_579244: Call_StorageObjectsInsert_579226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores new data blobs and associated metadata.
  ## 
  let valid = call_579244.validator(path, query, header, formData, body)
  let scheme = call_579244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579244.url(scheme.get, call_579244.host, call_579244.base,
                         call_579244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579244, url, valid)

proc call*(call_579245: Call_StorageObjectsInsert_579226; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          name: string = ""; ifGenerationMatch: string = "";
          ifGenerationNotMatch: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; ifMetagenerationMatch: string = "";
          body: JsonNode = nil; ifMetagenerationNotMatch: string = "";
          projection: string = "full"; fields: string = ""): Recallable =
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
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   body: JObject
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579246 = newJObject()
  var query_579247 = newJObject()
  var body_579248 = newJObject()
  add(query_579247, "key", newJString(key))
  add(query_579247, "prettyPrint", newJBool(prettyPrint))
  add(query_579247, "oauth_token", newJString(oauthToken))
  add(query_579247, "name", newJString(name))
  add(query_579247, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579247, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579247, "alt", newJString(alt))
  add(query_579247, "userIp", newJString(userIp))
  add(query_579247, "quotaUser", newJString(quotaUser))
  add(query_579247, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579246, "bucket", newJString(bucket))
  if body != nil:
    body_579248 = body
  add(query_579247, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579247, "projection", newJString(projection))
  add(query_579247, "fields", newJString(fields))
  result = call_579245.call(path_579246, query_579247, nil, nil, body_579248)

var storageObjectsInsert* = Call_StorageObjectsInsert_579226(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_579227, base: "/storage/v1beta2",
    url: url_StorageObjectsInsert_579228, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_579205 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsList_579207(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsList_579206(path: JsonNode; query: JsonNode;
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
  var valid_579208 = path.getOrDefault("bucket")
  valid_579208 = validateParameter(valid_579208, JString, required = true,
                                 default = nil)
  if valid_579208 != nil:
    section.add "bucket", valid_579208
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
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   versions: JBool
  ##           : If true, lists all versions of a file as distinct results.
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
  var valid_579212 = query.getOrDefault("prefix")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "prefix", valid_579212
  var valid_579213 = query.getOrDefault("alt")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = newJString("json"))
  if valid_579213 != nil:
    section.add "alt", valid_579213
  var valid_579214 = query.getOrDefault("userIp")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "userIp", valid_579214
  var valid_579215 = query.getOrDefault("quotaUser")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "quotaUser", valid_579215
  var valid_579216 = query.getOrDefault("pageToken")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "pageToken", valid_579216
  var valid_579217 = query.getOrDefault("projection")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = newJString("full"))
  if valid_579217 != nil:
    section.add "projection", valid_579217
  var valid_579218 = query.getOrDefault("fields")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "fields", valid_579218
  var valid_579219 = query.getOrDefault("delimiter")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "delimiter", valid_579219
  var valid_579220 = query.getOrDefault("maxResults")
  valid_579220 = validateParameter(valid_579220, JInt, required = false, default = nil)
  if valid_579220 != nil:
    section.add "maxResults", valid_579220
  var valid_579221 = query.getOrDefault("versions")
  valid_579221 = validateParameter(valid_579221, JBool, required = false, default = nil)
  if valid_579221 != nil:
    section.add "versions", valid_579221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579222: Call_StorageObjectsList_579205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_579222.validator(path, query, header, formData, body)
  let scheme = call_579222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579222.url(scheme.get, call_579222.host, call_579222.base,
                         call_579222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579222, url, valid)

proc call*(call_579223: Call_StorageObjectsList_579205; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          prefix: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; projection: string = "full";
          fields: string = ""; delimiter: string = ""; maxResults: int = 0;
          versions: bool = false): Recallable =
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
  ##   bucket: string (required)
  ##         : Name of the bucket in which to look for objects.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   versions: bool
  ##           : If true, lists all versions of a file as distinct results.
  var path_579224 = newJObject()
  var query_579225 = newJObject()
  add(query_579225, "key", newJString(key))
  add(query_579225, "prettyPrint", newJBool(prettyPrint))
  add(query_579225, "oauth_token", newJString(oauthToken))
  add(query_579225, "prefix", newJString(prefix))
  add(query_579225, "alt", newJString(alt))
  add(query_579225, "userIp", newJString(userIp))
  add(query_579225, "quotaUser", newJString(quotaUser))
  add(query_579225, "pageToken", newJString(pageToken))
  add(path_579224, "bucket", newJString(bucket))
  add(query_579225, "projection", newJString(projection))
  add(query_579225, "fields", newJString(fields))
  add(query_579225, "delimiter", newJString(delimiter))
  add(query_579225, "maxResults", newJInt(maxResults))
  add(query_579225, "versions", newJBool(versions))
  result = call_579223.call(path_579224, query_579225, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_579205(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_579206, base: "/storage/v1beta2",
    url: url_StorageObjectsList_579207, schemes: {Scheme.Https})
type
  Call_StorageObjectsWatchAll_579249 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsWatchAll_579251(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsWatchAll_579250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watch for changes on all objects in a bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to look for objects.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579252 = path.getOrDefault("bucket")
  valid_579252 = validateParameter(valid_579252, JString, required = true,
                                 default = nil)
  if valid_579252 != nil:
    section.add "bucket", valid_579252
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
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   versions: JBool
  ##           : If true, lists all versions of a file as distinct results.
  section = newJObject()
  var valid_579253 = query.getOrDefault("key")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "key", valid_579253
  var valid_579254 = query.getOrDefault("prettyPrint")
  valid_579254 = validateParameter(valid_579254, JBool, required = false,
                                 default = newJBool(true))
  if valid_579254 != nil:
    section.add "prettyPrint", valid_579254
  var valid_579255 = query.getOrDefault("oauth_token")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "oauth_token", valid_579255
  var valid_579256 = query.getOrDefault("prefix")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "prefix", valid_579256
  var valid_579257 = query.getOrDefault("alt")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = newJString("json"))
  if valid_579257 != nil:
    section.add "alt", valid_579257
  var valid_579258 = query.getOrDefault("userIp")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "userIp", valid_579258
  var valid_579259 = query.getOrDefault("quotaUser")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "quotaUser", valid_579259
  var valid_579260 = query.getOrDefault("pageToken")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "pageToken", valid_579260
  var valid_579261 = query.getOrDefault("projection")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = newJString("full"))
  if valid_579261 != nil:
    section.add "projection", valid_579261
  var valid_579262 = query.getOrDefault("fields")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "fields", valid_579262
  var valid_579263 = query.getOrDefault("delimiter")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "delimiter", valid_579263
  var valid_579264 = query.getOrDefault("maxResults")
  valid_579264 = validateParameter(valid_579264, JInt, required = false, default = nil)
  if valid_579264 != nil:
    section.add "maxResults", valid_579264
  var valid_579265 = query.getOrDefault("versions")
  valid_579265 = validateParameter(valid_579265, JBool, required = false, default = nil)
  if valid_579265 != nil:
    section.add "versions", valid_579265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579267: Call_StorageObjectsWatchAll_579249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes on all objects in a bucket.
  ## 
  let valid = call_579267.validator(path, query, header, formData, body)
  let scheme = call_579267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579267.url(scheme.get, call_579267.host, call_579267.base,
                         call_579267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579267, url, valid)

proc call*(call_579268: Call_StorageObjectsWatchAll_579249; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          prefix: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; resource: JsonNode = nil;
          projection: string = "full"; fields: string = ""; delimiter: string = "";
          maxResults: int = 0; versions: bool = false): Recallable =
  ## storageObjectsWatchAll
  ## Watch for changes on all objects in a bucket.
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
  ##   bucket: string (required)
  ##         : Name of the bucket in which to look for objects.
  ##   resource: JObject
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   versions: bool
  ##           : If true, lists all versions of a file as distinct results.
  var path_579269 = newJObject()
  var query_579270 = newJObject()
  var body_579271 = newJObject()
  add(query_579270, "key", newJString(key))
  add(query_579270, "prettyPrint", newJBool(prettyPrint))
  add(query_579270, "oauth_token", newJString(oauthToken))
  add(query_579270, "prefix", newJString(prefix))
  add(query_579270, "alt", newJString(alt))
  add(query_579270, "userIp", newJString(userIp))
  add(query_579270, "quotaUser", newJString(quotaUser))
  add(query_579270, "pageToken", newJString(pageToken))
  add(path_579269, "bucket", newJString(bucket))
  if resource != nil:
    body_579271 = resource
  add(query_579270, "projection", newJString(projection))
  add(query_579270, "fields", newJString(fields))
  add(query_579270, "delimiter", newJString(delimiter))
  add(query_579270, "maxResults", newJInt(maxResults))
  add(query_579270, "versions", newJBool(versions))
  result = call_579268.call(path_579269, query_579270, nil, nil, body_579271)

var storageObjectsWatchAll* = Call_StorageObjectsWatchAll_579249(
    name: "storageObjectsWatchAll", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/watch",
    validator: validate_StorageObjectsWatchAll_579250, base: "/storage/v1beta2",
    url: url_StorageObjectsWatchAll_579251, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_579294 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsUpdate_579296(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsUpdate_579295(path: JsonNode; query: JsonNode;
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
  var valid_579297 = path.getOrDefault("bucket")
  valid_579297 = validateParameter(valid_579297, JString, required = true,
                                 default = nil)
  if valid_579297 != nil:
    section.add "bucket", valid_579297
  var valid_579298 = path.getOrDefault("object")
  valid_579298 = validateParameter(valid_579298, JString, required = true,
                                 default = nil)
  if valid_579298 != nil:
    section.add "object", valid_579298
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579299 = query.getOrDefault("key")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "key", valid_579299
  var valid_579300 = query.getOrDefault("prettyPrint")
  valid_579300 = validateParameter(valid_579300, JBool, required = false,
                                 default = newJBool(true))
  if valid_579300 != nil:
    section.add "prettyPrint", valid_579300
  var valid_579301 = query.getOrDefault("oauth_token")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "oauth_token", valid_579301
  var valid_579302 = query.getOrDefault("generation")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "generation", valid_579302
  var valid_579303 = query.getOrDefault("ifGenerationMatch")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "ifGenerationMatch", valid_579303
  var valid_579304 = query.getOrDefault("ifGenerationNotMatch")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "ifGenerationNotMatch", valid_579304
  var valid_579305 = query.getOrDefault("alt")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = newJString("json"))
  if valid_579305 != nil:
    section.add "alt", valid_579305
  var valid_579306 = query.getOrDefault("userIp")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "userIp", valid_579306
  var valid_579307 = query.getOrDefault("quotaUser")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "quotaUser", valid_579307
  var valid_579308 = query.getOrDefault("ifMetagenerationMatch")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "ifMetagenerationMatch", valid_579308
  var valid_579309 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "ifMetagenerationNotMatch", valid_579309
  var valid_579310 = query.getOrDefault("projection")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = newJString("full"))
  if valid_579310 != nil:
    section.add "projection", valid_579310
  var valid_579311 = query.getOrDefault("fields")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "fields", valid_579311
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

proc call*(call_579313: Call_StorageObjectsUpdate_579294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata.
  ## 
  let valid = call_579313.validator(path, query, header, formData, body)
  let scheme = call_579313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579313.url(scheme.get, call_579313.host, call_579313.base,
                         call_579313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579313, url, valid)

proc call*(call_579314: Call_StorageObjectsUpdate_579294; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsUpdate
  ## Updates a data blob's associated metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   body: JObject
  ##   object: string (required)
  ##         : Name of the object.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579315 = newJObject()
  var query_579316 = newJObject()
  var body_579317 = newJObject()
  add(query_579316, "key", newJString(key))
  add(query_579316, "prettyPrint", newJBool(prettyPrint))
  add(query_579316, "oauth_token", newJString(oauthToken))
  add(query_579316, "generation", newJString(generation))
  add(query_579316, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579316, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579316, "alt", newJString(alt))
  add(query_579316, "userIp", newJString(userIp))
  add(query_579316, "quotaUser", newJString(quotaUser))
  add(query_579316, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579315, "bucket", newJString(bucket))
  if body != nil:
    body_579317 = body
  add(path_579315, "object", newJString(`object`))
  add(query_579316, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579316, "projection", newJString(projection))
  add(query_579316, "fields", newJString(fields))
  result = call_579314.call(path_579315, query_579316, nil, nil, body_579317)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_579294(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_579295, base: "/storage/v1beta2",
    url: url_StorageObjectsUpdate_579296, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_579272 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsGet_579274(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsGet_579273(path: JsonNode; query: JsonNode;
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
  var valid_579275 = path.getOrDefault("bucket")
  valid_579275 = validateParameter(valid_579275, JString, required = true,
                                 default = nil)
  if valid_579275 != nil:
    section.add "bucket", valid_579275
  var valid_579276 = path.getOrDefault("object")
  valid_579276 = validateParameter(valid_579276, JString, required = true,
                                 default = nil)
  if valid_579276 != nil:
    section.add "object", valid_579276
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's generation matches the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's generation does not match the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579277 = query.getOrDefault("key")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "key", valid_579277
  var valid_579278 = query.getOrDefault("prettyPrint")
  valid_579278 = validateParameter(valid_579278, JBool, required = false,
                                 default = newJBool(true))
  if valid_579278 != nil:
    section.add "prettyPrint", valid_579278
  var valid_579279 = query.getOrDefault("oauth_token")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "oauth_token", valid_579279
  var valid_579280 = query.getOrDefault("generation")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "generation", valid_579280
  var valid_579281 = query.getOrDefault("ifGenerationMatch")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "ifGenerationMatch", valid_579281
  var valid_579282 = query.getOrDefault("ifGenerationNotMatch")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "ifGenerationNotMatch", valid_579282
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
  var valid_579286 = query.getOrDefault("ifMetagenerationMatch")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "ifMetagenerationMatch", valid_579286
  var valid_579287 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "ifMetagenerationNotMatch", valid_579287
  var valid_579288 = query.getOrDefault("projection")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = newJString("full"))
  if valid_579288 != nil:
    section.add "projection", valid_579288
  var valid_579289 = query.getOrDefault("fields")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "fields", valid_579289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579290: Call_StorageObjectsGet_579272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves objects or their associated metadata.
  ## 
  let valid = call_579290.validator(path, query, header, formData, body)
  let scheme = call_579290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579290.url(scheme.get, call_579290.host, call_579290.base,
                         call_579290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579290, url, valid)

proc call*(call_579291: Call_StorageObjectsGet_579272; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; ifMetagenerationNotMatch: string = "";
          projection: string = "full"; fields: string = ""): Recallable =
  ## storageObjectsGet
  ## Retrieves objects or their associated metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's generation matches the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's generation does not match the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: string (required)
  ##         : Name of the object.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579292 = newJObject()
  var query_579293 = newJObject()
  add(query_579293, "key", newJString(key))
  add(query_579293, "prettyPrint", newJBool(prettyPrint))
  add(query_579293, "oauth_token", newJString(oauthToken))
  add(query_579293, "generation", newJString(generation))
  add(query_579293, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579293, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579293, "alt", newJString(alt))
  add(query_579293, "userIp", newJString(userIp))
  add(query_579293, "quotaUser", newJString(quotaUser))
  add(query_579293, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579292, "bucket", newJString(bucket))
  add(path_579292, "object", newJString(`object`))
  add(query_579293, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579293, "projection", newJString(projection))
  add(query_579293, "fields", newJString(fields))
  result = call_579291.call(path_579292, query_579293, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_579272(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_579273,
    base: "/storage/v1beta2", url: url_StorageObjectsGet_579274,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_579339 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsPatch_579341(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsPatch_579340(path: JsonNode; query: JsonNode;
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
  var valid_579342 = path.getOrDefault("bucket")
  valid_579342 = validateParameter(valid_579342, JString, required = true,
                                 default = nil)
  if valid_579342 != nil:
    section.add "bucket", valid_579342
  var valid_579343 = path.getOrDefault("object")
  valid_579343 = validateParameter(valid_579343, JString, required = true,
                                 default = nil)
  if valid_579343 != nil:
    section.add "object", valid_579343
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579344 = query.getOrDefault("key")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "key", valid_579344
  var valid_579345 = query.getOrDefault("prettyPrint")
  valid_579345 = validateParameter(valid_579345, JBool, required = false,
                                 default = newJBool(true))
  if valid_579345 != nil:
    section.add "prettyPrint", valid_579345
  var valid_579346 = query.getOrDefault("oauth_token")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "oauth_token", valid_579346
  var valid_579347 = query.getOrDefault("generation")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "generation", valid_579347
  var valid_579348 = query.getOrDefault("ifGenerationMatch")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "ifGenerationMatch", valid_579348
  var valid_579349 = query.getOrDefault("ifGenerationNotMatch")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "ifGenerationNotMatch", valid_579349
  var valid_579350 = query.getOrDefault("alt")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = newJString("json"))
  if valid_579350 != nil:
    section.add "alt", valid_579350
  var valid_579351 = query.getOrDefault("userIp")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "userIp", valid_579351
  var valid_579352 = query.getOrDefault("quotaUser")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "quotaUser", valid_579352
  var valid_579353 = query.getOrDefault("ifMetagenerationMatch")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "ifMetagenerationMatch", valid_579353
  var valid_579354 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "ifMetagenerationNotMatch", valid_579354
  var valid_579355 = query.getOrDefault("projection")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = newJString("full"))
  if valid_579355 != nil:
    section.add "projection", valid_579355
  var valid_579356 = query.getOrDefault("fields")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "fields", valid_579356
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

proc call*(call_579358: Call_StorageObjectsPatch_579339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ## 
  let valid = call_579358.validator(path, query, header, formData, body)
  let scheme = call_579358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579358.url(scheme.get, call_579358.host, call_579358.base,
                         call_579358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579358, url, valid)

proc call*(call_579359: Call_StorageObjectsPatch_579339; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsPatch
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   body: JObject
  ##   object: string (required)
  ##         : Name of the object.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579360 = newJObject()
  var query_579361 = newJObject()
  var body_579362 = newJObject()
  add(query_579361, "key", newJString(key))
  add(query_579361, "prettyPrint", newJBool(prettyPrint))
  add(query_579361, "oauth_token", newJString(oauthToken))
  add(query_579361, "generation", newJString(generation))
  add(query_579361, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579361, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579361, "alt", newJString(alt))
  add(query_579361, "userIp", newJString(userIp))
  add(query_579361, "quotaUser", newJString(quotaUser))
  add(query_579361, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579360, "bucket", newJString(bucket))
  if body != nil:
    body_579362 = body
  add(path_579360, "object", newJString(`object`))
  add(query_579361, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579361, "projection", newJString(projection))
  add(query_579361, "fields", newJString(fields))
  result = call_579359.call(path_579360, query_579361, nil, nil, body_579362)

var storageObjectsPatch* = Call_StorageObjectsPatch_579339(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_579340, base: "/storage/v1beta2",
    url: url_StorageObjectsPatch_579341, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_579318 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsDelete_579320(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsDelete_579319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes data blobs and associated metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
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
  var valid_579321 = path.getOrDefault("bucket")
  valid_579321 = validateParameter(valid_579321, JString, required = true,
                                 default = nil)
  if valid_579321 != nil:
    section.add "bucket", valid_579321
  var valid_579322 = path.getOrDefault("object")
  valid_579322 = validateParameter(valid_579322, JString, required = true,
                                 default = nil)
  if valid_579322 != nil:
    section.add "object", valid_579322
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, permanently deletes a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579323 = query.getOrDefault("key")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "key", valid_579323
  var valid_579324 = query.getOrDefault("prettyPrint")
  valid_579324 = validateParameter(valid_579324, JBool, required = false,
                                 default = newJBool(true))
  if valid_579324 != nil:
    section.add "prettyPrint", valid_579324
  var valid_579325 = query.getOrDefault("oauth_token")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "oauth_token", valid_579325
  var valid_579326 = query.getOrDefault("generation")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "generation", valid_579326
  var valid_579327 = query.getOrDefault("ifGenerationMatch")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "ifGenerationMatch", valid_579327
  var valid_579328 = query.getOrDefault("ifGenerationNotMatch")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "ifGenerationNotMatch", valid_579328
  var valid_579329 = query.getOrDefault("alt")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = newJString("json"))
  if valid_579329 != nil:
    section.add "alt", valid_579329
  var valid_579330 = query.getOrDefault("userIp")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "userIp", valid_579330
  var valid_579331 = query.getOrDefault("quotaUser")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "quotaUser", valid_579331
  var valid_579332 = query.getOrDefault("ifMetagenerationMatch")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "ifMetagenerationMatch", valid_579332
  var valid_579333 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "ifMetagenerationNotMatch", valid_579333
  var valid_579334 = query.getOrDefault("fields")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "fields", valid_579334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579335: Call_StorageObjectsDelete_579318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes data blobs and associated metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  let valid = call_579335.validator(path, query, header, formData, body)
  let scheme = call_579335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579335.url(scheme.get, call_579335.host, call_579335.base,
                         call_579335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579335, url, valid)

proc call*(call_579336: Call_StorageObjectsDelete_579318; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; ifMetagenerationNotMatch: string = "";
          fields: string = ""): Recallable =
  ## storageObjectsDelete
  ## Deletes data blobs and associated metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, permanently deletes a specific revision of this object (as opposed to the latest version, the default).
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: string (required)
  ##         : Name of the object.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579337 = newJObject()
  var query_579338 = newJObject()
  add(query_579338, "key", newJString(key))
  add(query_579338, "prettyPrint", newJBool(prettyPrint))
  add(query_579338, "oauth_token", newJString(oauthToken))
  add(query_579338, "generation", newJString(generation))
  add(query_579338, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579338, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579338, "alt", newJString(alt))
  add(query_579338, "userIp", newJString(userIp))
  add(query_579338, "quotaUser", newJString(quotaUser))
  add(query_579338, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579337, "bucket", newJString(bucket))
  add(path_579337, "object", newJString(`object`))
  add(query_579338, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579338, "fields", newJString(fields))
  result = call_579336.call(path_579337, query_579338, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_579318(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_579319, base: "/storage/v1beta2",
    url: url_StorageObjectsDelete_579320, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_579380 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsInsert_579382(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsInsert_579381(path: JsonNode;
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
  var valid_579383 = path.getOrDefault("bucket")
  valid_579383 = validateParameter(valid_579383, JString, required = true,
                                 default = nil)
  if valid_579383 != nil:
    section.add "bucket", valid_579383
  var valid_579384 = path.getOrDefault("object")
  valid_579384 = validateParameter(valid_579384, JString, required = true,
                                 default = nil)
  if valid_579384 != nil:
    section.add "object", valid_579384
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579385 = query.getOrDefault("key")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "key", valid_579385
  var valid_579386 = query.getOrDefault("prettyPrint")
  valid_579386 = validateParameter(valid_579386, JBool, required = false,
                                 default = newJBool(true))
  if valid_579386 != nil:
    section.add "prettyPrint", valid_579386
  var valid_579387 = query.getOrDefault("oauth_token")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "oauth_token", valid_579387
  var valid_579388 = query.getOrDefault("generation")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "generation", valid_579388
  var valid_579389 = query.getOrDefault("alt")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = newJString("json"))
  if valid_579389 != nil:
    section.add "alt", valid_579389
  var valid_579390 = query.getOrDefault("userIp")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "userIp", valid_579390
  var valid_579391 = query.getOrDefault("quotaUser")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = nil)
  if valid_579391 != nil:
    section.add "quotaUser", valid_579391
  var valid_579392 = query.getOrDefault("fields")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "fields", valid_579392
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

proc call*(call_579394: Call_StorageObjectAccessControlsInsert_579380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_579394.validator(path, query, header, formData, body)
  let scheme = call_579394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579394.url(scheme.get, call_579394.host, call_579394.base,
                         call_579394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579394, url, valid)

proc call*(call_579395: Call_StorageObjectAccessControlsInsert_579380;
          bucket: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## storageObjectAccessControlsInsert
  ## Creates a new ACL entry on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
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
  var path_579396 = newJObject()
  var query_579397 = newJObject()
  var body_579398 = newJObject()
  add(query_579397, "key", newJString(key))
  add(query_579397, "prettyPrint", newJBool(prettyPrint))
  add(query_579397, "oauth_token", newJString(oauthToken))
  add(query_579397, "generation", newJString(generation))
  add(query_579397, "alt", newJString(alt))
  add(query_579397, "userIp", newJString(userIp))
  add(query_579397, "quotaUser", newJString(quotaUser))
  add(path_579396, "bucket", newJString(bucket))
  if body != nil:
    body_579398 = body
  add(path_579396, "object", newJString(`object`))
  add(query_579397, "fields", newJString(fields))
  result = call_579395.call(path_579396, query_579397, nil, nil, body_579398)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_579380(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_579381,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsInsert_579382,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_579363 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsList_579365(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsList_579364(path: JsonNode;
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
  var valid_579366 = path.getOrDefault("bucket")
  valid_579366 = validateParameter(valid_579366, JString, required = true,
                                 default = nil)
  if valid_579366 != nil:
    section.add "bucket", valid_579366
  var valid_579367 = path.getOrDefault("object")
  valid_579367 = validateParameter(valid_579367, JString, required = true,
                                 default = nil)
  if valid_579367 != nil:
    section.add "object", valid_579367
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579368 = query.getOrDefault("key")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "key", valid_579368
  var valid_579369 = query.getOrDefault("prettyPrint")
  valid_579369 = validateParameter(valid_579369, JBool, required = false,
                                 default = newJBool(true))
  if valid_579369 != nil:
    section.add "prettyPrint", valid_579369
  var valid_579370 = query.getOrDefault("oauth_token")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "oauth_token", valid_579370
  var valid_579371 = query.getOrDefault("generation")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "generation", valid_579371
  var valid_579372 = query.getOrDefault("alt")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = newJString("json"))
  if valid_579372 != nil:
    section.add "alt", valid_579372
  var valid_579373 = query.getOrDefault("userIp")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "userIp", valid_579373
  var valid_579374 = query.getOrDefault("quotaUser")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "quotaUser", valid_579374
  var valid_579375 = query.getOrDefault("fields")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "fields", valid_579375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579376: Call_StorageObjectAccessControlsList_579363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_579376.validator(path, query, header, formData, body)
  let scheme = call_579376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579376.url(scheme.get, call_579376.host, call_579376.base,
                         call_579376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579376, url, valid)

proc call*(call_579377: Call_StorageObjectAccessControlsList_579363;
          bucket: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsList
  ## Retrieves ACL entries on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
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
  var path_579378 = newJObject()
  var query_579379 = newJObject()
  add(query_579379, "key", newJString(key))
  add(query_579379, "prettyPrint", newJBool(prettyPrint))
  add(query_579379, "oauth_token", newJString(oauthToken))
  add(query_579379, "generation", newJString(generation))
  add(query_579379, "alt", newJString(alt))
  add(query_579379, "userIp", newJString(userIp))
  add(query_579379, "quotaUser", newJString(quotaUser))
  add(path_579378, "bucket", newJString(bucket))
  add(path_579378, "object", newJString(`object`))
  add(query_579379, "fields", newJString(fields))
  result = call_579377.call(path_579378, query_579379, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_579363(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_579364,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsList_579365,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_579417 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsUpdate_579419(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsUpdate_579418(path: JsonNode;
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
  var valid_579420 = path.getOrDefault("bucket")
  valid_579420 = validateParameter(valid_579420, JString, required = true,
                                 default = nil)
  if valid_579420 != nil:
    section.add "bucket", valid_579420
  var valid_579421 = path.getOrDefault("entity")
  valid_579421 = validateParameter(valid_579421, JString, required = true,
                                 default = nil)
  if valid_579421 != nil:
    section.add "entity", valid_579421
  var valid_579422 = path.getOrDefault("object")
  valid_579422 = validateParameter(valid_579422, JString, required = true,
                                 default = nil)
  if valid_579422 != nil:
    section.add "object", valid_579422
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579423 = query.getOrDefault("key")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "key", valid_579423
  var valid_579424 = query.getOrDefault("prettyPrint")
  valid_579424 = validateParameter(valid_579424, JBool, required = false,
                                 default = newJBool(true))
  if valid_579424 != nil:
    section.add "prettyPrint", valid_579424
  var valid_579425 = query.getOrDefault("oauth_token")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "oauth_token", valid_579425
  var valid_579426 = query.getOrDefault("generation")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "generation", valid_579426
  var valid_579427 = query.getOrDefault("alt")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = newJString("json"))
  if valid_579427 != nil:
    section.add "alt", valid_579427
  var valid_579428 = query.getOrDefault("userIp")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "userIp", valid_579428
  var valid_579429 = query.getOrDefault("quotaUser")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "quotaUser", valid_579429
  var valid_579430 = query.getOrDefault("fields")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = nil)
  if valid_579430 != nil:
    section.add "fields", valid_579430
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

proc call*(call_579432: Call_StorageObjectAccessControlsUpdate_579417;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_579432.validator(path, query, header, formData, body)
  let scheme = call_579432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579432.url(scheme.get, call_579432.host, call_579432.base,
                         call_579432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579432, url, valid)

proc call*(call_579433: Call_StorageObjectAccessControlsUpdate_579417;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageObjectAccessControlsUpdate
  ## Updates an ACL entry on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
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
  var path_579434 = newJObject()
  var query_579435 = newJObject()
  var body_579436 = newJObject()
  add(query_579435, "key", newJString(key))
  add(query_579435, "prettyPrint", newJBool(prettyPrint))
  add(query_579435, "oauth_token", newJString(oauthToken))
  add(query_579435, "generation", newJString(generation))
  add(query_579435, "alt", newJString(alt))
  add(query_579435, "userIp", newJString(userIp))
  add(query_579435, "quotaUser", newJString(quotaUser))
  add(path_579434, "bucket", newJString(bucket))
  if body != nil:
    body_579436 = body
  add(path_579434, "entity", newJString(entity))
  add(path_579434, "object", newJString(`object`))
  add(query_579435, "fields", newJString(fields))
  result = call_579433.call(path_579434, query_579435, nil, nil, body_579436)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_579417(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_579418,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsUpdate_579419,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_579399 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsGet_579401(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsGet_579400(path: JsonNode;
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
  var valid_579402 = path.getOrDefault("bucket")
  valid_579402 = validateParameter(valid_579402, JString, required = true,
                                 default = nil)
  if valid_579402 != nil:
    section.add "bucket", valid_579402
  var valid_579403 = path.getOrDefault("entity")
  valid_579403 = validateParameter(valid_579403, JString, required = true,
                                 default = nil)
  if valid_579403 != nil:
    section.add "entity", valid_579403
  var valid_579404 = path.getOrDefault("object")
  valid_579404 = validateParameter(valid_579404, JString, required = true,
                                 default = nil)
  if valid_579404 != nil:
    section.add "object", valid_579404
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579405 = query.getOrDefault("key")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "key", valid_579405
  var valid_579406 = query.getOrDefault("prettyPrint")
  valid_579406 = validateParameter(valid_579406, JBool, required = false,
                                 default = newJBool(true))
  if valid_579406 != nil:
    section.add "prettyPrint", valid_579406
  var valid_579407 = query.getOrDefault("oauth_token")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "oauth_token", valid_579407
  var valid_579408 = query.getOrDefault("generation")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "generation", valid_579408
  var valid_579409 = query.getOrDefault("alt")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = newJString("json"))
  if valid_579409 != nil:
    section.add "alt", valid_579409
  var valid_579410 = query.getOrDefault("userIp")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "userIp", valid_579410
  var valid_579411 = query.getOrDefault("quotaUser")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "quotaUser", valid_579411
  var valid_579412 = query.getOrDefault("fields")
  valid_579412 = validateParameter(valid_579412, JString, required = false,
                                 default = nil)
  if valid_579412 != nil:
    section.add "fields", valid_579412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579413: Call_StorageObjectAccessControlsGet_579399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_579413.validator(path, query, header, formData, body)
  let scheme = call_579413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579413.url(scheme.get, call_579413.host, call_579413.base,
                         call_579413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579413, url, valid)

proc call*(call_579414: Call_StorageObjectAccessControlsGet_579399; bucket: string;
          entity: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
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
  var path_579415 = newJObject()
  var query_579416 = newJObject()
  add(query_579416, "key", newJString(key))
  add(query_579416, "prettyPrint", newJBool(prettyPrint))
  add(query_579416, "oauth_token", newJString(oauthToken))
  add(query_579416, "generation", newJString(generation))
  add(query_579416, "alt", newJString(alt))
  add(query_579416, "userIp", newJString(userIp))
  add(query_579416, "quotaUser", newJString(quotaUser))
  add(path_579415, "bucket", newJString(bucket))
  add(path_579415, "entity", newJString(entity))
  add(path_579415, "object", newJString(`object`))
  add(query_579416, "fields", newJString(fields))
  result = call_579414.call(path_579415, query_579416, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_579399(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_579400,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsGet_579401,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_579455 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsPatch_579457(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsPatch_579456(path: JsonNode;
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
  var valid_579458 = path.getOrDefault("bucket")
  valid_579458 = validateParameter(valid_579458, JString, required = true,
                                 default = nil)
  if valid_579458 != nil:
    section.add "bucket", valid_579458
  var valid_579459 = path.getOrDefault("entity")
  valid_579459 = validateParameter(valid_579459, JString, required = true,
                                 default = nil)
  if valid_579459 != nil:
    section.add "entity", valid_579459
  var valid_579460 = path.getOrDefault("object")
  valid_579460 = validateParameter(valid_579460, JString, required = true,
                                 default = nil)
  if valid_579460 != nil:
    section.add "object", valid_579460
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579461 = query.getOrDefault("key")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "key", valid_579461
  var valid_579462 = query.getOrDefault("prettyPrint")
  valid_579462 = validateParameter(valid_579462, JBool, required = false,
                                 default = newJBool(true))
  if valid_579462 != nil:
    section.add "prettyPrint", valid_579462
  var valid_579463 = query.getOrDefault("oauth_token")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "oauth_token", valid_579463
  var valid_579464 = query.getOrDefault("generation")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "generation", valid_579464
  var valid_579465 = query.getOrDefault("alt")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = newJString("json"))
  if valid_579465 != nil:
    section.add "alt", valid_579465
  var valid_579466 = query.getOrDefault("userIp")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "userIp", valid_579466
  var valid_579467 = query.getOrDefault("quotaUser")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "quotaUser", valid_579467
  var valid_579468 = query.getOrDefault("fields")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "fields", valid_579468
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

proc call*(call_579470: Call_StorageObjectAccessControlsPatch_579455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ## 
  let valid = call_579470.validator(path, query, header, formData, body)
  let scheme = call_579470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579470.url(scheme.get, call_579470.host, call_579470.base,
                         call_579470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579470, url, valid)

proc call*(call_579471: Call_StorageObjectAccessControlsPatch_579455;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageObjectAccessControlsPatch
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
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
  var path_579472 = newJObject()
  var query_579473 = newJObject()
  var body_579474 = newJObject()
  add(query_579473, "key", newJString(key))
  add(query_579473, "prettyPrint", newJBool(prettyPrint))
  add(query_579473, "oauth_token", newJString(oauthToken))
  add(query_579473, "generation", newJString(generation))
  add(query_579473, "alt", newJString(alt))
  add(query_579473, "userIp", newJString(userIp))
  add(query_579473, "quotaUser", newJString(quotaUser))
  add(path_579472, "bucket", newJString(bucket))
  if body != nil:
    body_579474 = body
  add(path_579472, "entity", newJString(entity))
  add(path_579472, "object", newJString(`object`))
  add(query_579473, "fields", newJString(fields))
  result = call_579471.call(path_579472, query_579473, nil, nil, body_579474)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_579455(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_579456,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsPatch_579457,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_579437 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsDelete_579439(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsDelete_579438(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
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
  var valid_579440 = path.getOrDefault("bucket")
  valid_579440 = validateParameter(valid_579440, JString, required = true,
                                 default = nil)
  if valid_579440 != nil:
    section.add "bucket", valid_579440
  var valid_579441 = path.getOrDefault("entity")
  valid_579441 = validateParameter(valid_579441, JString, required = true,
                                 default = nil)
  if valid_579441 != nil:
    section.add "entity", valid_579441
  var valid_579442 = path.getOrDefault("object")
  valid_579442 = validateParameter(valid_579442, JString, required = true,
                                 default = nil)
  if valid_579442 != nil:
    section.add "object", valid_579442
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579443 = query.getOrDefault("key")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "key", valid_579443
  var valid_579444 = query.getOrDefault("prettyPrint")
  valid_579444 = validateParameter(valid_579444, JBool, required = false,
                                 default = newJBool(true))
  if valid_579444 != nil:
    section.add "prettyPrint", valid_579444
  var valid_579445 = query.getOrDefault("oauth_token")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "oauth_token", valid_579445
  var valid_579446 = query.getOrDefault("generation")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "generation", valid_579446
  var valid_579447 = query.getOrDefault("alt")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = newJString("json"))
  if valid_579447 != nil:
    section.add "alt", valid_579447
  var valid_579448 = query.getOrDefault("userIp")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "userIp", valid_579448
  var valid_579449 = query.getOrDefault("quotaUser")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "quotaUser", valid_579449
  var valid_579450 = query.getOrDefault("fields")
  valid_579450 = validateParameter(valid_579450, JString, required = false,
                                 default = nil)
  if valid_579450 != nil:
    section.add "fields", valid_579450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579451: Call_StorageObjectAccessControlsDelete_579437;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_579451.validator(path, query, header, formData, body)
  let scheme = call_579451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579451.url(scheme.get, call_579451.host, call_579451.base,
                         call_579451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579451, url, valid)

proc call*(call_579452: Call_StorageObjectAccessControlsDelete_579437;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## storageObjectAccessControlsDelete
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
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
  var path_579453 = newJObject()
  var query_579454 = newJObject()
  add(query_579454, "key", newJString(key))
  add(query_579454, "prettyPrint", newJBool(prettyPrint))
  add(query_579454, "oauth_token", newJString(oauthToken))
  add(query_579454, "generation", newJString(generation))
  add(query_579454, "alt", newJString(alt))
  add(query_579454, "userIp", newJString(userIp))
  add(query_579454, "quotaUser", newJString(quotaUser))
  add(path_579453, "bucket", newJString(bucket))
  add(path_579453, "entity", newJString(entity))
  add(path_579453, "object", newJString(`object`))
  add(query_579454, "fields", newJString(fields))
  result = call_579452.call(path_579453, query_579454, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_579437(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_579438,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsDelete_579439,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsCompose_579475 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsCompose_579477(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "destinationBucket" in path,
        "`destinationBucket` is a required path parameter"
  assert "destinationObject" in path,
        "`destinationObject` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject"),
               (kind: ConstantSegment, value: "/compose")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsCompose_579476(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationObject: JString (required)
  ##                    : Name of the new object.
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationObject` field"
  var valid_579478 = path.getOrDefault("destinationObject")
  valid_579478 = validateParameter(valid_579478, JString, required = true,
                                 default = nil)
  if valid_579478 != nil:
    section.add "destinationObject", valid_579478
  var valid_579479 = path.getOrDefault("destinationBucket")
  valid_579479 = validateParameter(valid_579479, JString, required = true,
                                 default = nil)
  if valid_579479 != nil:
    section.add "destinationBucket", valid_579479
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579480 = query.getOrDefault("key")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = nil)
  if valid_579480 != nil:
    section.add "key", valid_579480
  var valid_579481 = query.getOrDefault("prettyPrint")
  valid_579481 = validateParameter(valid_579481, JBool, required = false,
                                 default = newJBool(true))
  if valid_579481 != nil:
    section.add "prettyPrint", valid_579481
  var valid_579482 = query.getOrDefault("oauth_token")
  valid_579482 = validateParameter(valid_579482, JString, required = false,
                                 default = nil)
  if valid_579482 != nil:
    section.add "oauth_token", valid_579482
  var valid_579483 = query.getOrDefault("ifGenerationMatch")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "ifGenerationMatch", valid_579483
  var valid_579484 = query.getOrDefault("alt")
  valid_579484 = validateParameter(valid_579484, JString, required = false,
                                 default = newJString("json"))
  if valid_579484 != nil:
    section.add "alt", valid_579484
  var valid_579485 = query.getOrDefault("userIp")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "userIp", valid_579485
  var valid_579486 = query.getOrDefault("quotaUser")
  valid_579486 = validateParameter(valid_579486, JString, required = false,
                                 default = nil)
  if valid_579486 != nil:
    section.add "quotaUser", valid_579486
  var valid_579487 = query.getOrDefault("ifMetagenerationMatch")
  valid_579487 = validateParameter(valid_579487, JString, required = false,
                                 default = nil)
  if valid_579487 != nil:
    section.add "ifMetagenerationMatch", valid_579487
  var valid_579488 = query.getOrDefault("fields")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "fields", valid_579488
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

proc call*(call_579490: Call_StorageObjectsCompose_579475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  let valid = call_579490.validator(path, query, header, formData, body)
  let scheme = call_579490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579490.url(scheme.get, call_579490.host, call_579490.base,
                         call_579490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579490, url, valid)

proc call*(call_579491: Call_StorageObjectsCompose_579475;
          destinationObject: string; destinationBucket: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          ifGenerationMatch: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; ifMetagenerationMatch: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageObjectsCompose
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   destinationObject: string (required)
  ##                    : Name of the new object.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579492 = newJObject()
  var query_579493 = newJObject()
  var body_579494 = newJObject()
  add(query_579493, "key", newJString(key))
  add(query_579493, "prettyPrint", newJBool(prettyPrint))
  add(query_579493, "oauth_token", newJString(oauthToken))
  add(path_579492, "destinationObject", newJString(destinationObject))
  add(path_579492, "destinationBucket", newJString(destinationBucket))
  add(query_579493, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579493, "alt", newJString(alt))
  add(query_579493, "userIp", newJString(userIp))
  add(query_579493, "quotaUser", newJString(quotaUser))
  add(query_579493, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_579494 = body
  add(query_579493, "fields", newJString(fields))
  result = call_579491.call(path_579492, query_579493, nil, nil, body_579494)

var storageObjectsCompose* = Call_StorageObjectsCompose_579475(
    name: "storageObjectsCompose", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com",
    route: "/b/{destinationBucket}/o/{destinationObject}/compose",
    validator: validate_StorageObjectsCompose_579476, base: "/storage/v1beta2",
    url: url_StorageObjectsCompose_579477, schemes: {Scheme.Https})
type
  Call_StorageObjectsCopy_579495 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsCopy_579497(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceBucket" in path, "`sourceBucket` is a required path parameter"
  assert "sourceObject" in path, "`sourceObject` is a required path parameter"
  assert "destinationBucket" in path,
        "`destinationBucket` is a required path parameter"
  assert "destinationObject" in path,
        "`destinationObject` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "sourceBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "sourceObject"),
               (kind: ConstantSegment, value: "/copyTo/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsCopy_579496(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Copies an object to a destination in the same location. Optionally overrides metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   sourceObject: JString (required)
  ##               : Name of the source object.
  ##   sourceBucket: JString (required)
  ##               : Name of the bucket in which to find the source object.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationObject` field"
  var valid_579498 = path.getOrDefault("destinationObject")
  valid_579498 = validateParameter(valid_579498, JString, required = true,
                                 default = nil)
  if valid_579498 != nil:
    section.add "destinationObject", valid_579498
  var valid_579499 = path.getOrDefault("destinationBucket")
  valid_579499 = validateParameter(valid_579499, JString, required = true,
                                 default = nil)
  if valid_579499 != nil:
    section.add "destinationBucket", valid_579499
  var valid_579500 = path.getOrDefault("sourceObject")
  valid_579500 = validateParameter(valid_579500, JString, required = true,
                                 default = nil)
  if valid_579500 != nil:
    section.add "sourceObject", valid_579500
  var valid_579501 = path.getOrDefault("sourceBucket")
  valid_579501 = validateParameter(valid_579501, JString, required = true,
                                 default = nil)
  if valid_579501 != nil:
    section.add "sourceBucket", valid_579501
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: JString
  ##                          : Makes the operation conditional on whether the source object's generation matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   ifSourceMetagenerationNotMatch: JString
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: JString
  ##                             : Makes the operation conditional on whether the source object's generation does not match the given value.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   sourceGeneration: JString
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: JString
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579502 = query.getOrDefault("key")
  valid_579502 = validateParameter(valid_579502, JString, required = false,
                                 default = nil)
  if valid_579502 != nil:
    section.add "key", valid_579502
  var valid_579503 = query.getOrDefault("ifSourceGenerationMatch")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = nil)
  if valid_579503 != nil:
    section.add "ifSourceGenerationMatch", valid_579503
  var valid_579504 = query.getOrDefault("prettyPrint")
  valid_579504 = validateParameter(valid_579504, JBool, required = false,
                                 default = newJBool(true))
  if valid_579504 != nil:
    section.add "prettyPrint", valid_579504
  var valid_579505 = query.getOrDefault("oauth_token")
  valid_579505 = validateParameter(valid_579505, JString, required = false,
                                 default = nil)
  if valid_579505 != nil:
    section.add "oauth_token", valid_579505
  var valid_579506 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = nil)
  if valid_579506 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_579506
  var valid_579507 = query.getOrDefault("ifGenerationMatch")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "ifGenerationMatch", valid_579507
  var valid_579508 = query.getOrDefault("alt")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = newJString("json"))
  if valid_579508 != nil:
    section.add "alt", valid_579508
  var valid_579509 = query.getOrDefault("userIp")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "userIp", valid_579509
  var valid_579510 = query.getOrDefault("ifGenerationNotMatch")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "ifGenerationNotMatch", valid_579510
  var valid_579511 = query.getOrDefault("quotaUser")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "quotaUser", valid_579511
  var valid_579512 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "ifSourceGenerationNotMatch", valid_579512
  var valid_579513 = query.getOrDefault("ifMetagenerationMatch")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "ifMetagenerationMatch", valid_579513
  var valid_579514 = query.getOrDefault("sourceGeneration")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "sourceGeneration", valid_579514
  var valid_579515 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "ifSourceMetagenerationMatch", valid_579515
  var valid_579516 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "ifMetagenerationNotMatch", valid_579516
  var valid_579517 = query.getOrDefault("projection")
  valid_579517 = validateParameter(valid_579517, JString, required = false,
                                 default = newJString("full"))
  if valid_579517 != nil:
    section.add "projection", valid_579517
  var valid_579518 = query.getOrDefault("fields")
  valid_579518 = validateParameter(valid_579518, JString, required = false,
                                 default = nil)
  if valid_579518 != nil:
    section.add "fields", valid_579518
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

proc call*(call_579520: Call_StorageObjectsCopy_579495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies an object to a destination in the same location. Optionally overrides metadata.
  ## 
  let valid = call_579520.validator(path, query, header, formData, body)
  let scheme = call_579520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579520.url(scheme.get, call_579520.host, call_579520.base,
                         call_579520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579520, url, valid)

proc call*(call_579521: Call_StorageObjectsCopy_579495; destinationObject: string;
          destinationBucket: string; sourceObject: string; sourceBucket: string;
          key: string = ""; ifSourceGenerationMatch: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          ifSourceMetagenerationNotMatch: string = "";
          ifGenerationMatch: string = ""; alt: string = "json"; userIp: string = "";
          ifGenerationNotMatch: string = ""; quotaUser: string = "";
          ifSourceGenerationNotMatch: string = "";
          ifMetagenerationMatch: string = ""; sourceGeneration: string = "";
          ifSourceMetagenerationMatch: string = ""; body: JsonNode = nil;
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsCopy
  ## Copies an object to a destination in the same location. Optionally overrides metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: string
  ##                          : Makes the operation conditional on whether the source object's generation matches the given value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   ifSourceMetagenerationNotMatch: string
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: string
  ##                             : Makes the operation conditional on whether the source object's generation does not match the given value.
  ##   sourceObject: string (required)
  ##               : Name of the source object.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   sourceGeneration: string
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: string
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   sourceBucket: string (required)
  ##               : Name of the bucket in which to find the source object.
  ##   body: JObject
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579522 = newJObject()
  var query_579523 = newJObject()
  var body_579524 = newJObject()
  add(query_579523, "key", newJString(key))
  add(query_579523, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_579523, "prettyPrint", newJBool(prettyPrint))
  add(query_579523, "oauth_token", newJString(oauthToken))
  add(path_579522, "destinationObject", newJString(destinationObject))
  add(query_579523, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(path_579522, "destinationBucket", newJString(destinationBucket))
  add(query_579523, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579523, "alt", newJString(alt))
  add(query_579523, "userIp", newJString(userIp))
  add(query_579523, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579523, "quotaUser", newJString(quotaUser))
  add(query_579523, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  add(path_579522, "sourceObject", newJString(sourceObject))
  add(query_579523, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_579523, "sourceGeneration", newJString(sourceGeneration))
  add(query_579523, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(path_579522, "sourceBucket", newJString(sourceBucket))
  if body != nil:
    body_579524 = body
  add(query_579523, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579523, "projection", newJString(projection))
  add(query_579523, "fields", newJString(fields))
  result = call_579521.call(path_579522, query_579523, nil, nil, body_579524)

var storageObjectsCopy* = Call_StorageObjectsCopy_579495(
    name: "storageObjectsCopy", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/copyTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsCopy_579496, base: "/storage/v1beta2",
    url: url_StorageObjectsCopy_579497, schemes: {Scheme.Https})
type
  Call_StorageChannelsStop_579525 = ref object of OpenApiRestCall_578355
proc url_StorageChannelsStop_579527(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageChannelsStop_579526(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579528 = query.getOrDefault("key")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "key", valid_579528
  var valid_579529 = query.getOrDefault("prettyPrint")
  valid_579529 = validateParameter(valid_579529, JBool, required = false,
                                 default = newJBool(true))
  if valid_579529 != nil:
    section.add "prettyPrint", valid_579529
  var valid_579530 = query.getOrDefault("oauth_token")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "oauth_token", valid_579530
  var valid_579531 = query.getOrDefault("alt")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = newJString("json"))
  if valid_579531 != nil:
    section.add "alt", valid_579531
  var valid_579532 = query.getOrDefault("userIp")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "userIp", valid_579532
  var valid_579533 = query.getOrDefault("quotaUser")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "quotaUser", valid_579533
  var valid_579534 = query.getOrDefault("fields")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "fields", valid_579534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579536: Call_StorageChannelsStop_579525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_579536.validator(path, query, header, formData, body)
  let scheme = call_579536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579536.url(scheme.get, call_579536.host, call_579536.base,
                         call_579536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579536, url, valid)

proc call*(call_579537: Call_StorageChannelsStop_579525; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; resource: JsonNode = nil;
          fields: string = ""): Recallable =
  ## storageChannelsStop
  ## Stop watching resources through this channel
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
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579538 = newJObject()
  var body_579539 = newJObject()
  add(query_579538, "key", newJString(key))
  add(query_579538, "prettyPrint", newJBool(prettyPrint))
  add(query_579538, "oauth_token", newJString(oauthToken))
  add(query_579538, "alt", newJString(alt))
  add(query_579538, "userIp", newJString(userIp))
  add(query_579538, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_579539 = resource
  add(query_579538, "fields", newJString(fields))
  result = call_579537.call(nil, query_579538, nil, nil, body_579539)

var storageChannelsStop* = Call_StorageChannelsStop_579525(
    name: "storageChannelsStop", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/channels/stop",
    validator: validate_StorageChannelsStop_579526, base: "/storage/v1beta2",
    url: url_StorageChannelsStop_579527, schemes: {Scheme.Https})
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
