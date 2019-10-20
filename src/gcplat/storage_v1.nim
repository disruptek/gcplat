
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Storage
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Stores and retrieves potentially large, immutable data objects.
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
  Call_StorageBucketsInsert_578901 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsInsert_578903(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageBucketsInsert_578902(path: JsonNode; query: JsonNode;
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: JString (required)
  ##          : A valid API project identifier.
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578904 = query.getOrDefault("key")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "key", valid_578904
  var valid_578905 = query.getOrDefault("prettyPrint")
  valid_578905 = validateParameter(valid_578905, JBool, required = false,
                                 default = newJBool(true))
  if valid_578905 != nil:
    section.add "prettyPrint", valid_578905
  var valid_578906 = query.getOrDefault("oauth_token")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "oauth_token", valid_578906
  var valid_578907 = query.getOrDefault("userProject")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "userProject", valid_578907
  var valid_578908 = query.getOrDefault("predefinedAcl")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_578908 != nil:
    section.add "predefinedAcl", valid_578908
  var valid_578909 = query.getOrDefault("alt")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("json"))
  if valid_578909 != nil:
    section.add "alt", valid_578909
  var valid_578910 = query.getOrDefault("userIp")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "userIp", valid_578910
  var valid_578911 = query.getOrDefault("quotaUser")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "quotaUser", valid_578911
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_578912 = query.getOrDefault("project")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "project", valid_578912
  var valid_578913 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_578913 != nil:
    section.add "predefinedDefaultObjectAcl", valid_578913
  var valid_578914 = query.getOrDefault("provisionalUserProject")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "provisionalUserProject", valid_578914
  var valid_578915 = query.getOrDefault("projection")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("full"))
  if valid_578915 != nil:
    section.add "projection", valid_578915
  var valid_578916 = query.getOrDefault("fields")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "fields", valid_578916
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

proc call*(call_578918: Call_StorageBucketsInsert_578901; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_578918.validator(path, query, header, formData, body)
  let scheme = call_578918.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578918.url(scheme.get, call_578918.host, call_578918.base,
                         call_578918.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578918, url, valid)

proc call*(call_578919: Call_StorageBucketsInsert_578901; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; predefinedAcl: string = "authenticatedRead";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil;
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageBucketsInsert
  ## Creates a new bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   body: JObject
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578920 = newJObject()
  var body_578921 = newJObject()
  add(query_578920, "key", newJString(key))
  add(query_578920, "prettyPrint", newJBool(prettyPrint))
  add(query_578920, "oauth_token", newJString(oauthToken))
  add(query_578920, "userProject", newJString(userProject))
  add(query_578920, "predefinedAcl", newJString(predefinedAcl))
  add(query_578920, "alt", newJString(alt))
  add(query_578920, "userIp", newJString(userIp))
  add(query_578920, "quotaUser", newJString(quotaUser))
  add(query_578920, "project", newJString(project))
  if body != nil:
    body_578921 = body
  add(query_578920, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_578920, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_578920, "projection", newJString(projection))
  add(query_578920, "fields", newJString(fields))
  result = call_578919.call(nil, query_578920, nil, nil, body_578921)

var storageBucketsInsert* = Call_StorageBucketsInsert_578901(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_578902, base: "/storage/v1",
    url: url_StorageBucketsInsert_578903, schemes: {Scheme.Https})
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
  ##   prefix: JString
  ##         : Filter results to buckets whose names begin with this prefix.
  ##   userProject: JString
  ##              : The project to be billed for this request.
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
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of buckets to return in a single response. The service will use this parameter or 1,000 items, whichever is smaller.
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
  var valid_578755 = query.getOrDefault("prefix")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "prefix", valid_578755
  var valid_578756 = query.getOrDefault("userProject")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "userProject", valid_578756
  var valid_578757 = query.getOrDefault("alt")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = newJString("json"))
  if valid_578757 != nil:
    section.add "alt", valid_578757
  var valid_578758 = query.getOrDefault("userIp")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "userIp", valid_578758
  var valid_578759 = query.getOrDefault("quotaUser")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "quotaUser", valid_578759
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_578760 = query.getOrDefault("project")
  valid_578760 = validateParameter(valid_578760, JString, required = true,
                                 default = nil)
  if valid_578760 != nil:
    section.add "project", valid_578760
  var valid_578761 = query.getOrDefault("pageToken")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "pageToken", valid_578761
  var valid_578762 = query.getOrDefault("provisionalUserProject")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "provisionalUserProject", valid_578762
  var valid_578763 = query.getOrDefault("projection")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = newJString("full"))
  if valid_578763 != nil:
    section.add "projection", valid_578763
  var valid_578764 = query.getOrDefault("fields")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "fields", valid_578764
  var valid_578766 = query.getOrDefault("maxResults")
  valid_578766 = validateParameter(valid_578766, JInt, required = false,
                                 default = newJInt(1000))
  if valid_578766 != nil:
    section.add "maxResults", valid_578766
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578789: Call_StorageBucketsList_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of buckets for a given project.
  ## 
  let valid = call_578789.validator(path, query, header, formData, body)
  let scheme = call_578789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578789.url(scheme.get, call_578789.host, call_578789.base,
                         call_578789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578789, url, valid)

proc call*(call_578860: Call_StorageBucketsList_578625; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          prefix: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          provisionalUserProject: string = ""; projection: string = "full";
          fields: string = ""; maxResults: int = 1000): Recallable =
  ## storageBucketsList
  ## Retrieves a list of buckets for a given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   prefix: string
  ##         : Filter results to buckets whose names begin with this prefix.
  ##   userProject: string
  ##              : The project to be billed for this request.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of buckets to return in a single response. The service will use this parameter or 1,000 items, whichever is smaller.
  var query_578861 = newJObject()
  add(query_578861, "key", newJString(key))
  add(query_578861, "prettyPrint", newJBool(prettyPrint))
  add(query_578861, "oauth_token", newJString(oauthToken))
  add(query_578861, "prefix", newJString(prefix))
  add(query_578861, "userProject", newJString(userProject))
  add(query_578861, "alt", newJString(alt))
  add(query_578861, "userIp", newJString(userIp))
  add(query_578861, "quotaUser", newJString(quotaUser))
  add(query_578861, "project", newJString(project))
  add(query_578861, "pageToken", newJString(pageToken))
  add(query_578861, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_578861, "projection", newJString(projection))
  add(query_578861, "fields", newJString(fields))
  add(query_578861, "maxResults", newJInt(maxResults))
  result = call_578860.call(nil, query_578861, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_578625(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b", validator: validate_StorageBucketsList_578626,
    base: "/storage/v1", url: url_StorageBucketsList_578627, schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_578956 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsUpdate_578958(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsUpdate_578957(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_578959 = path.getOrDefault("bucket")
  valid_578959 = validateParameter(valid_578959, JString, required = true,
                                 default = nil)
  if valid_578959 != nil:
    section.add "bucket", valid_578959
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_578963 = query.getOrDefault("userProject")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "userProject", valid_578963
  var valid_578964 = query.getOrDefault("predefinedAcl")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_578964 != nil:
    section.add "predefinedAcl", valid_578964
  var valid_578965 = query.getOrDefault("alt")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("json"))
  if valid_578965 != nil:
    section.add "alt", valid_578965
  var valid_578966 = query.getOrDefault("userIp")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "userIp", valid_578966
  var valid_578967 = query.getOrDefault("quotaUser")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "quotaUser", valid_578967
  var valid_578968 = query.getOrDefault("ifMetagenerationMatch")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "ifMetagenerationMatch", valid_578968
  var valid_578969 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_578969 != nil:
    section.add "predefinedDefaultObjectAcl", valid_578969
  var valid_578970 = query.getOrDefault("provisionalUserProject")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "provisionalUserProject", valid_578970
  var valid_578971 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "ifMetagenerationNotMatch", valid_578971
  var valid_578972 = query.getOrDefault("projection")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = newJString("full"))
  if valid_578972 != nil:
    section.add "projection", valid_578972
  var valid_578973 = query.getOrDefault("fields")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "fields", valid_578973
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

proc call*(call_578975: Call_StorageBucketsUpdate_578956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  let valid = call_578975.validator(path, query, header, formData, body)
  let scheme = call_578975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578975.url(scheme.get, call_578975.host, call_578975.base,
                         call_578975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578975, url, valid)

proc call*(call_578976: Call_StorageBucketsUpdate_578956; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; predefinedAcl: string = "authenticatedRead";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageBucketsUpdate
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
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
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578977 = newJObject()
  var query_578978 = newJObject()
  var body_578979 = newJObject()
  add(query_578978, "key", newJString(key))
  add(query_578978, "prettyPrint", newJBool(prettyPrint))
  add(query_578978, "oauth_token", newJString(oauthToken))
  add(query_578978, "userProject", newJString(userProject))
  add(query_578978, "predefinedAcl", newJString(predefinedAcl))
  add(query_578978, "alt", newJString(alt))
  add(query_578978, "userIp", newJString(userIp))
  add(query_578978, "quotaUser", newJString(quotaUser))
  add(query_578978, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_578977, "bucket", newJString(bucket))
  if body != nil:
    body_578979 = body
  add(query_578978, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_578978, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_578978, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_578978, "projection", newJString(projection))
  add(query_578978, "fields", newJString(fields))
  result = call_578976.call(path_578977, query_578978, nil, nil, body_578979)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_578956(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_578957, base: "/storage/v1",
    url: url_StorageBucketsUpdate_578958, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_578922 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsGet_578924(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsGet_578923(path: JsonNode; query: JsonNode;
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
  var valid_578939 = path.getOrDefault("bucket")
  valid_578939 = validateParameter(valid_578939, JString, required = true,
                                 default = nil)
  if valid_578939 != nil:
    section.add "bucket", valid_578939
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578940 = query.getOrDefault("key")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "key", valid_578940
  var valid_578941 = query.getOrDefault("prettyPrint")
  valid_578941 = validateParameter(valid_578941, JBool, required = false,
                                 default = newJBool(true))
  if valid_578941 != nil:
    section.add "prettyPrint", valid_578941
  var valid_578942 = query.getOrDefault("oauth_token")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "oauth_token", valid_578942
  var valid_578943 = query.getOrDefault("userProject")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "userProject", valid_578943
  var valid_578944 = query.getOrDefault("alt")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = newJString("json"))
  if valid_578944 != nil:
    section.add "alt", valid_578944
  var valid_578945 = query.getOrDefault("userIp")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "userIp", valid_578945
  var valid_578946 = query.getOrDefault("quotaUser")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "quotaUser", valid_578946
  var valid_578947 = query.getOrDefault("ifMetagenerationMatch")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "ifMetagenerationMatch", valid_578947
  var valid_578948 = query.getOrDefault("provisionalUserProject")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "provisionalUserProject", valid_578948
  var valid_578949 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "ifMetagenerationNotMatch", valid_578949
  var valid_578950 = query.getOrDefault("projection")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = newJString("full"))
  if valid_578950 != nil:
    section.add "projection", valid_578950
  var valid_578951 = query.getOrDefault("fields")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "fields", valid_578951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578952: Call_StorageBucketsGet_578922; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_578952.validator(path, query, header, formData, body)
  let scheme = call_578952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578952.url(scheme.get, call_578952.host, call_578952.base,
                         call_578952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578952, url, valid)

proc call*(call_578953: Call_StorageBucketsGet_578922; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; ifMetagenerationMatch: string = "";
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageBucketsGet
  ## Returns metadata for the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578954 = newJObject()
  var query_578955 = newJObject()
  add(query_578955, "key", newJString(key))
  add(query_578955, "prettyPrint", newJBool(prettyPrint))
  add(query_578955, "oauth_token", newJString(oauthToken))
  add(query_578955, "userProject", newJString(userProject))
  add(query_578955, "alt", newJString(alt))
  add(query_578955, "userIp", newJString(userIp))
  add(query_578955, "quotaUser", newJString(quotaUser))
  add(query_578955, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_578954, "bucket", newJString(bucket))
  add(query_578955, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_578955, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_578955, "projection", newJString(projection))
  add(query_578955, "fields", newJString(fields))
  result = call_578953.call(path_578954, query_578955, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_578922(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_578923, base: "/storage/v1",
    url: url_StorageBucketsGet_578924, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_578999 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsPatch_579001(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsPatch_579000(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579002 = path.getOrDefault("bucket")
  valid_579002 = validateParameter(valid_579002, JString, required = true,
                                 default = nil)
  if valid_579002 != nil:
    section.add "bucket", valid_579002
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579003 = query.getOrDefault("key")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "key", valid_579003
  var valid_579004 = query.getOrDefault("prettyPrint")
  valid_579004 = validateParameter(valid_579004, JBool, required = false,
                                 default = newJBool(true))
  if valid_579004 != nil:
    section.add "prettyPrint", valid_579004
  var valid_579005 = query.getOrDefault("oauth_token")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "oauth_token", valid_579005
  var valid_579006 = query.getOrDefault("userProject")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "userProject", valid_579006
  var valid_579007 = query.getOrDefault("predefinedAcl")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579007 != nil:
    section.add "predefinedAcl", valid_579007
  var valid_579008 = query.getOrDefault("alt")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("json"))
  if valid_579008 != nil:
    section.add "alt", valid_579008
  var valid_579009 = query.getOrDefault("userIp")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "userIp", valid_579009
  var valid_579010 = query.getOrDefault("quotaUser")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "quotaUser", valid_579010
  var valid_579011 = query.getOrDefault("ifMetagenerationMatch")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "ifMetagenerationMatch", valid_579011
  var valid_579012 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579012 != nil:
    section.add "predefinedDefaultObjectAcl", valid_579012
  var valid_579013 = query.getOrDefault("provisionalUserProject")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "provisionalUserProject", valid_579013
  var valid_579014 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "ifMetagenerationNotMatch", valid_579014
  var valid_579015 = query.getOrDefault("projection")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = newJString("full"))
  if valid_579015 != nil:
    section.add "projection", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
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

proc call*(call_579018: Call_StorageBucketsPatch_578999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  let valid = call_579018.validator(path, query, header, formData, body)
  let scheme = call_579018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579018.url(scheme.get, call_579018.host, call_579018.base,
                         call_579018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579018, url, valid)

proc call*(call_579019: Call_StorageBucketsPatch_578999; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; predefinedAcl: string = "authenticatedRead";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageBucketsPatch
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
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
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579020 = newJObject()
  var query_579021 = newJObject()
  var body_579022 = newJObject()
  add(query_579021, "key", newJString(key))
  add(query_579021, "prettyPrint", newJBool(prettyPrint))
  add(query_579021, "oauth_token", newJString(oauthToken))
  add(query_579021, "userProject", newJString(userProject))
  add(query_579021, "predefinedAcl", newJString(predefinedAcl))
  add(query_579021, "alt", newJString(alt))
  add(query_579021, "userIp", newJString(userIp))
  add(query_579021, "quotaUser", newJString(quotaUser))
  add(query_579021, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579020, "bucket", newJString(bucket))
  if body != nil:
    body_579022 = body
  add(query_579021, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_579021, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579021, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579021, "projection", newJString(projection))
  add(query_579021, "fields", newJString(fields))
  result = call_579019.call(path_579020, query_579021, nil, nil, body_579022)

var storageBucketsPatch* = Call_StorageBucketsPatch_578999(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_579000, base: "/storage/v1",
    url: url_StorageBucketsPatch_579001, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_578980 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsDelete_578982(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsDelete_578981(path: JsonNode; query: JsonNode;
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
  var valid_578983 = path.getOrDefault("bucket")
  valid_578983 = validateParameter(valid_578983, JString, required = true,
                                 default = nil)
  if valid_578983 != nil:
    section.add "bucket", valid_578983
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : If set, only deletes the bucket if its metageneration matches this value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : If set, only deletes the bucket if its metageneration does not match this value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578984 = query.getOrDefault("key")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "key", valid_578984
  var valid_578985 = query.getOrDefault("prettyPrint")
  valid_578985 = validateParameter(valid_578985, JBool, required = false,
                                 default = newJBool(true))
  if valid_578985 != nil:
    section.add "prettyPrint", valid_578985
  var valid_578986 = query.getOrDefault("oauth_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "oauth_token", valid_578986
  var valid_578987 = query.getOrDefault("userProject")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "userProject", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("userIp")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "userIp", valid_578989
  var valid_578990 = query.getOrDefault("quotaUser")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "quotaUser", valid_578990
  var valid_578991 = query.getOrDefault("ifMetagenerationMatch")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "ifMetagenerationMatch", valid_578991
  var valid_578992 = query.getOrDefault("provisionalUserProject")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "provisionalUserProject", valid_578992
  var valid_578993 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "ifMetagenerationNotMatch", valid_578993
  var valid_578994 = query.getOrDefault("fields")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "fields", valid_578994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578995: Call_StorageBucketsDelete_578980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes an empty bucket.
  ## 
  let valid = call_578995.validator(path, query, header, formData, body)
  let scheme = call_578995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578995.url(scheme.get, call_578995.host, call_578995.base,
                         call_578995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578995, url, valid)

proc call*(call_578996: Call_StorageBucketsDelete_578980; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; ifMetagenerationMatch: string = "";
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; fields: string = ""): Recallable =
  ## storageBucketsDelete
  ## Permanently deletes an empty bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : If set, only deletes the bucket if its metageneration matches this value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : If set, only deletes the bucket if its metageneration does not match this value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578997 = newJObject()
  var query_578998 = newJObject()
  add(query_578998, "key", newJString(key))
  add(query_578998, "prettyPrint", newJBool(prettyPrint))
  add(query_578998, "oauth_token", newJString(oauthToken))
  add(query_578998, "userProject", newJString(userProject))
  add(query_578998, "alt", newJString(alt))
  add(query_578998, "userIp", newJString(userIp))
  add(query_578998, "quotaUser", newJString(quotaUser))
  add(query_578998, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_578997, "bucket", newJString(bucket))
  add(query_578998, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_578998, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_578998, "fields", newJString(fields))
  result = call_578996.call(path_578997, query_578998, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_578980(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_578981, base: "/storage/v1",
    url: url_StorageBucketsDelete_578982, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_579040 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsInsert_579042(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsInsert_579041(path: JsonNode;
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
  var valid_579043 = path.getOrDefault("bucket")
  valid_579043 = validateParameter(valid_579043, JString, required = true,
                                 default = nil)
  if valid_579043 != nil:
    section.add "bucket", valid_579043
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579044 = query.getOrDefault("key")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "key", valid_579044
  var valid_579045 = query.getOrDefault("prettyPrint")
  valid_579045 = validateParameter(valid_579045, JBool, required = false,
                                 default = newJBool(true))
  if valid_579045 != nil:
    section.add "prettyPrint", valid_579045
  var valid_579046 = query.getOrDefault("oauth_token")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "oauth_token", valid_579046
  var valid_579047 = query.getOrDefault("userProject")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "userProject", valid_579047
  var valid_579048 = query.getOrDefault("alt")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = newJString("json"))
  if valid_579048 != nil:
    section.add "alt", valid_579048
  var valid_579049 = query.getOrDefault("userIp")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "userIp", valid_579049
  var valid_579050 = query.getOrDefault("quotaUser")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "quotaUser", valid_579050
  var valid_579051 = query.getOrDefault("provisionalUserProject")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "provisionalUserProject", valid_579051
  var valid_579052 = query.getOrDefault("fields")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "fields", valid_579052
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

proc call*(call_579054: Call_StorageBucketAccessControlsInsert_579040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_579054.validator(path, query, header, formData, body)
  let scheme = call_579054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579054.url(scheme.get, call_579054.host, call_579054.base,
                         call_579054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579054, url, valid)

proc call*(call_579055: Call_StorageBucketAccessControlsInsert_579040;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsInsert
  ## Creates a new ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579056 = newJObject()
  var query_579057 = newJObject()
  var body_579058 = newJObject()
  add(query_579057, "key", newJString(key))
  add(query_579057, "prettyPrint", newJBool(prettyPrint))
  add(query_579057, "oauth_token", newJString(oauthToken))
  add(query_579057, "userProject", newJString(userProject))
  add(query_579057, "alt", newJString(alt))
  add(query_579057, "userIp", newJString(userIp))
  add(query_579057, "quotaUser", newJString(quotaUser))
  add(path_579056, "bucket", newJString(bucket))
  if body != nil:
    body_579058 = body
  add(query_579057, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579057, "fields", newJString(fields))
  result = call_579055.call(path_579056, query_579057, nil, nil, body_579058)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_579040(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_579041,
    base: "/storage/v1", url: url_StorageBucketAccessControlsInsert_579042,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_579023 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsList_579025(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsList_579024(path: JsonNode;
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
  var valid_579026 = path.getOrDefault("bucket")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "bucket", valid_579026
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579027 = query.getOrDefault("key")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "key", valid_579027
  var valid_579028 = query.getOrDefault("prettyPrint")
  valid_579028 = validateParameter(valid_579028, JBool, required = false,
                                 default = newJBool(true))
  if valid_579028 != nil:
    section.add "prettyPrint", valid_579028
  var valid_579029 = query.getOrDefault("oauth_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "oauth_token", valid_579029
  var valid_579030 = query.getOrDefault("userProject")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "userProject", valid_579030
  var valid_579031 = query.getOrDefault("alt")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("json"))
  if valid_579031 != nil:
    section.add "alt", valid_579031
  var valid_579032 = query.getOrDefault("userIp")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "userIp", valid_579032
  var valid_579033 = query.getOrDefault("quotaUser")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "quotaUser", valid_579033
  var valid_579034 = query.getOrDefault("provisionalUserProject")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "provisionalUserProject", valid_579034
  var valid_579035 = query.getOrDefault("fields")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "fields", valid_579035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579036: Call_StorageBucketAccessControlsList_579023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_579036.validator(path, query, header, formData, body)
  let scheme = call_579036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579036.url(scheme.get, call_579036.host, call_579036.base,
                         call_579036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579036, url, valid)

proc call*(call_579037: Call_StorageBucketAccessControlsList_579023;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsList
  ## Retrieves ACL entries on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579038 = newJObject()
  var query_579039 = newJObject()
  add(query_579039, "key", newJString(key))
  add(query_579039, "prettyPrint", newJBool(prettyPrint))
  add(query_579039, "oauth_token", newJString(oauthToken))
  add(query_579039, "userProject", newJString(userProject))
  add(query_579039, "alt", newJString(alt))
  add(query_579039, "userIp", newJString(userIp))
  add(query_579039, "quotaUser", newJString(quotaUser))
  add(path_579038, "bucket", newJString(bucket))
  add(query_579039, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579039, "fields", newJString(fields))
  result = call_579037.call(path_579038, query_579039, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_579023(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_579024,
    base: "/storage/v1", url: url_StorageBucketAccessControlsList_579025,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_579077 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsUpdate_579079(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsUpdate_579078(path: JsonNode;
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
  var valid_579080 = path.getOrDefault("bucket")
  valid_579080 = validateParameter(valid_579080, JString, required = true,
                                 default = nil)
  if valid_579080 != nil:
    section.add "bucket", valid_579080
  var valid_579081 = path.getOrDefault("entity")
  valid_579081 = validateParameter(valid_579081, JString, required = true,
                                 default = nil)
  if valid_579081 != nil:
    section.add "entity", valid_579081
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579082 = query.getOrDefault("key")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "key", valid_579082
  var valid_579083 = query.getOrDefault("prettyPrint")
  valid_579083 = validateParameter(valid_579083, JBool, required = false,
                                 default = newJBool(true))
  if valid_579083 != nil:
    section.add "prettyPrint", valid_579083
  var valid_579084 = query.getOrDefault("oauth_token")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "oauth_token", valid_579084
  var valid_579085 = query.getOrDefault("userProject")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "userProject", valid_579085
  var valid_579086 = query.getOrDefault("alt")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = newJString("json"))
  if valid_579086 != nil:
    section.add "alt", valid_579086
  var valid_579087 = query.getOrDefault("userIp")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "userIp", valid_579087
  var valid_579088 = query.getOrDefault("quotaUser")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "quotaUser", valid_579088
  var valid_579089 = query.getOrDefault("provisionalUserProject")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "provisionalUserProject", valid_579089
  var valid_579090 = query.getOrDefault("fields")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "fields", valid_579090
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

proc call*(call_579092: Call_StorageBucketAccessControlsUpdate_579077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_579092.validator(path, query, header, formData, body)
  let scheme = call_579092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579092.url(scheme.get, call_579092.host, call_579092.base,
                         call_579092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579092, url, valid)

proc call*(call_579093: Call_StorageBucketAccessControlsUpdate_579077;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsUpdate
  ## Updates an ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579094 = newJObject()
  var query_579095 = newJObject()
  var body_579096 = newJObject()
  add(query_579095, "key", newJString(key))
  add(query_579095, "prettyPrint", newJBool(prettyPrint))
  add(query_579095, "oauth_token", newJString(oauthToken))
  add(query_579095, "userProject", newJString(userProject))
  add(query_579095, "alt", newJString(alt))
  add(query_579095, "userIp", newJString(userIp))
  add(query_579095, "quotaUser", newJString(quotaUser))
  add(path_579094, "bucket", newJString(bucket))
  if body != nil:
    body_579096 = body
  add(query_579095, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579094, "entity", newJString(entity))
  add(query_579095, "fields", newJString(fields))
  result = call_579093.call(path_579094, query_579095, nil, nil, body_579096)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_579077(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_579078,
    base: "/storage/v1", url: url_StorageBucketAccessControlsUpdate_579079,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_579059 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsGet_579061(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsGet_579060(path: JsonNode;
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
  var valid_579062 = path.getOrDefault("bucket")
  valid_579062 = validateParameter(valid_579062, JString, required = true,
                                 default = nil)
  if valid_579062 != nil:
    section.add "bucket", valid_579062
  var valid_579063 = path.getOrDefault("entity")
  valid_579063 = validateParameter(valid_579063, JString, required = true,
                                 default = nil)
  if valid_579063 != nil:
    section.add "entity", valid_579063
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579064 = query.getOrDefault("key")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "key", valid_579064
  var valid_579065 = query.getOrDefault("prettyPrint")
  valid_579065 = validateParameter(valid_579065, JBool, required = false,
                                 default = newJBool(true))
  if valid_579065 != nil:
    section.add "prettyPrint", valid_579065
  var valid_579066 = query.getOrDefault("oauth_token")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "oauth_token", valid_579066
  var valid_579067 = query.getOrDefault("userProject")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "userProject", valid_579067
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
  var valid_579071 = query.getOrDefault("provisionalUserProject")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "provisionalUserProject", valid_579071
  var valid_579072 = query.getOrDefault("fields")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "fields", valid_579072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579073: Call_StorageBucketAccessControlsGet_579059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_579073.validator(path, query, header, formData, body)
  let scheme = call_579073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579073.url(scheme.get, call_579073.host, call_579073.base,
                         call_579073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579073, url, valid)

proc call*(call_579074: Call_StorageBucketAccessControlsGet_579059; bucket: string;
          entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579075 = newJObject()
  var query_579076 = newJObject()
  add(query_579076, "key", newJString(key))
  add(query_579076, "prettyPrint", newJBool(prettyPrint))
  add(query_579076, "oauth_token", newJString(oauthToken))
  add(query_579076, "userProject", newJString(userProject))
  add(query_579076, "alt", newJString(alt))
  add(query_579076, "userIp", newJString(userIp))
  add(query_579076, "quotaUser", newJString(quotaUser))
  add(path_579075, "bucket", newJString(bucket))
  add(query_579076, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579075, "entity", newJString(entity))
  add(query_579076, "fields", newJString(fields))
  result = call_579074.call(path_579075, query_579076, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_579059(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_579060,
    base: "/storage/v1", url: url_StorageBucketAccessControlsGet_579061,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_579115 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsPatch_579117(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsPatch_579116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches an ACL entry on the specified bucket.
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
  var valid_579118 = path.getOrDefault("bucket")
  valid_579118 = validateParameter(valid_579118, JString, required = true,
                                 default = nil)
  if valid_579118 != nil:
    section.add "bucket", valid_579118
  var valid_579119 = path.getOrDefault("entity")
  valid_579119 = validateParameter(valid_579119, JString, required = true,
                                 default = nil)
  if valid_579119 != nil:
    section.add "entity", valid_579119
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579120 = query.getOrDefault("key")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "key", valid_579120
  var valid_579121 = query.getOrDefault("prettyPrint")
  valid_579121 = validateParameter(valid_579121, JBool, required = false,
                                 default = newJBool(true))
  if valid_579121 != nil:
    section.add "prettyPrint", valid_579121
  var valid_579122 = query.getOrDefault("oauth_token")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "oauth_token", valid_579122
  var valid_579123 = query.getOrDefault("userProject")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "userProject", valid_579123
  var valid_579124 = query.getOrDefault("alt")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = newJString("json"))
  if valid_579124 != nil:
    section.add "alt", valid_579124
  var valid_579125 = query.getOrDefault("userIp")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "userIp", valid_579125
  var valid_579126 = query.getOrDefault("quotaUser")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "quotaUser", valid_579126
  var valid_579127 = query.getOrDefault("provisionalUserProject")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "provisionalUserProject", valid_579127
  var valid_579128 = query.getOrDefault("fields")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "fields", valid_579128
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

proc call*(call_579130: Call_StorageBucketAccessControlsPatch_579115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches an ACL entry on the specified bucket.
  ## 
  let valid = call_579130.validator(path, query, header, formData, body)
  let scheme = call_579130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579130.url(scheme.get, call_579130.host, call_579130.base,
                         call_579130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579130, url, valid)

proc call*(call_579131: Call_StorageBucketAccessControlsPatch_579115;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsPatch
  ## Patches an ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579132 = newJObject()
  var query_579133 = newJObject()
  var body_579134 = newJObject()
  add(query_579133, "key", newJString(key))
  add(query_579133, "prettyPrint", newJBool(prettyPrint))
  add(query_579133, "oauth_token", newJString(oauthToken))
  add(query_579133, "userProject", newJString(userProject))
  add(query_579133, "alt", newJString(alt))
  add(query_579133, "userIp", newJString(userIp))
  add(query_579133, "quotaUser", newJString(quotaUser))
  add(path_579132, "bucket", newJString(bucket))
  if body != nil:
    body_579134 = body
  add(query_579133, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579132, "entity", newJString(entity))
  add(query_579133, "fields", newJString(fields))
  result = call_579131.call(path_579132, query_579133, nil, nil, body_579134)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_579115(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_579116,
    base: "/storage/v1", url: url_StorageBucketAccessControlsPatch_579117,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_579097 = ref object of OpenApiRestCall_578355
proc url_StorageBucketAccessControlsDelete_579099(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsDelete_579098(path: JsonNode;
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
  var valid_579100 = path.getOrDefault("bucket")
  valid_579100 = validateParameter(valid_579100, JString, required = true,
                                 default = nil)
  if valid_579100 != nil:
    section.add "bucket", valid_579100
  var valid_579101 = path.getOrDefault("entity")
  valid_579101 = validateParameter(valid_579101, JString, required = true,
                                 default = nil)
  if valid_579101 != nil:
    section.add "entity", valid_579101
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579102 = query.getOrDefault("key")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "key", valid_579102
  var valid_579103 = query.getOrDefault("prettyPrint")
  valid_579103 = validateParameter(valid_579103, JBool, required = false,
                                 default = newJBool(true))
  if valid_579103 != nil:
    section.add "prettyPrint", valid_579103
  var valid_579104 = query.getOrDefault("oauth_token")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "oauth_token", valid_579104
  var valid_579105 = query.getOrDefault("userProject")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "userProject", valid_579105
  var valid_579106 = query.getOrDefault("alt")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("json"))
  if valid_579106 != nil:
    section.add "alt", valid_579106
  var valid_579107 = query.getOrDefault("userIp")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "userIp", valid_579107
  var valid_579108 = query.getOrDefault("quotaUser")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "quotaUser", valid_579108
  var valid_579109 = query.getOrDefault("provisionalUserProject")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "provisionalUserProject", valid_579109
  var valid_579110 = query.getOrDefault("fields")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "fields", valid_579110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579111: Call_StorageBucketAccessControlsDelete_579097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_579111.validator(path, query, header, formData, body)
  let scheme = call_579111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579111.url(scheme.get, call_579111.host, call_579111.base,
                         call_579111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579111, url, valid)

proc call*(call_579112: Call_StorageBucketAccessControlsDelete_579097;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketAccessControlsDelete
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579113 = newJObject()
  var query_579114 = newJObject()
  add(query_579114, "key", newJString(key))
  add(query_579114, "prettyPrint", newJBool(prettyPrint))
  add(query_579114, "oauth_token", newJString(oauthToken))
  add(query_579114, "userProject", newJString(userProject))
  add(query_579114, "alt", newJString(alt))
  add(query_579114, "userIp", newJString(userIp))
  add(query_579114, "quotaUser", newJString(quotaUser))
  add(path_579113, "bucket", newJString(bucket))
  add(query_579114, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579113, "entity", newJString(entity))
  add(query_579114, "fields", newJString(fields))
  result = call_579112.call(path_579113, query_579114, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_579097(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_579098,
    base: "/storage/v1", url: url_StorageBucketAccessControlsDelete_579099,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsInsert_579154 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsInsert_579156(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsInsert_579155(path: JsonNode;
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
  var valid_579157 = path.getOrDefault("bucket")
  valid_579157 = validateParameter(valid_579157, JString, required = true,
                                 default = nil)
  if valid_579157 != nil:
    section.add "bucket", valid_579157
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
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
  var valid_579161 = query.getOrDefault("userProject")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "userProject", valid_579161
  var valid_579162 = query.getOrDefault("alt")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = newJString("json"))
  if valid_579162 != nil:
    section.add "alt", valid_579162
  var valid_579163 = query.getOrDefault("userIp")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "userIp", valid_579163
  var valid_579164 = query.getOrDefault("quotaUser")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "quotaUser", valid_579164
  var valid_579165 = query.getOrDefault("provisionalUserProject")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "provisionalUserProject", valid_579165
  var valid_579166 = query.getOrDefault("fields")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "fields", valid_579166
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

proc call*(call_579168: Call_StorageDefaultObjectAccessControlsInsert_579154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  let valid = call_579168.validator(path, query, header, formData, body)
  let scheme = call_579168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579168.url(scheme.get, call_579168.host, call_579168.base,
                         call_579168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579168, url, valid)

proc call*(call_579169: Call_StorageDefaultObjectAccessControlsInsert_579154;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsInsert
  ## Creates a new default object ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579170 = newJObject()
  var query_579171 = newJObject()
  var body_579172 = newJObject()
  add(query_579171, "key", newJString(key))
  add(query_579171, "prettyPrint", newJBool(prettyPrint))
  add(query_579171, "oauth_token", newJString(oauthToken))
  add(query_579171, "userProject", newJString(userProject))
  add(query_579171, "alt", newJString(alt))
  add(query_579171, "userIp", newJString(userIp))
  add(query_579171, "quotaUser", newJString(quotaUser))
  add(path_579170, "bucket", newJString(bucket))
  if body != nil:
    body_579172 = body
  add(query_579171, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579171, "fields", newJString(fields))
  result = call_579169.call(path_579170, query_579171, nil, nil, body_579172)

var storageDefaultObjectAccessControlsInsert* = Call_StorageDefaultObjectAccessControlsInsert_579154(
    name: "storageDefaultObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsInsert_579155,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsInsert_579156,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsList_579135 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsList_579137(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsList_579136(path: JsonNode;
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
  var valid_579138 = path.getOrDefault("bucket")
  valid_579138 = validateParameter(valid_579138, JString, required = true,
                                 default = nil)
  if valid_579138 != nil:
    section.add "bucket", valid_579138
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579139 = query.getOrDefault("key")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "key", valid_579139
  var valid_579140 = query.getOrDefault("prettyPrint")
  valid_579140 = validateParameter(valid_579140, JBool, required = false,
                                 default = newJBool(true))
  if valid_579140 != nil:
    section.add "prettyPrint", valid_579140
  var valid_579141 = query.getOrDefault("oauth_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "oauth_token", valid_579141
  var valid_579142 = query.getOrDefault("userProject")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "userProject", valid_579142
  var valid_579143 = query.getOrDefault("alt")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = newJString("json"))
  if valid_579143 != nil:
    section.add "alt", valid_579143
  var valid_579144 = query.getOrDefault("userIp")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "userIp", valid_579144
  var valid_579145 = query.getOrDefault("quotaUser")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "quotaUser", valid_579145
  var valid_579146 = query.getOrDefault("ifMetagenerationMatch")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "ifMetagenerationMatch", valid_579146
  var valid_579147 = query.getOrDefault("provisionalUserProject")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "provisionalUserProject", valid_579147
  var valid_579148 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "ifMetagenerationNotMatch", valid_579148
  var valid_579149 = query.getOrDefault("fields")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "fields", valid_579149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579150: Call_StorageDefaultObjectAccessControlsList_579135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  let valid = call_579150.validator(path, query, header, formData, body)
  let scheme = call_579150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579150.url(scheme.get, call_579150.host, call_579150.base,
                         call_579150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579150, url, valid)

proc call*(call_579151: Call_StorageDefaultObjectAccessControlsList_579135;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsList
  ## Retrieves default object ACL entries on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579152 = newJObject()
  var query_579153 = newJObject()
  add(query_579153, "key", newJString(key))
  add(query_579153, "prettyPrint", newJBool(prettyPrint))
  add(query_579153, "oauth_token", newJString(oauthToken))
  add(query_579153, "userProject", newJString(userProject))
  add(query_579153, "alt", newJString(alt))
  add(query_579153, "userIp", newJString(userIp))
  add(query_579153, "quotaUser", newJString(quotaUser))
  add(query_579153, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579152, "bucket", newJString(bucket))
  add(query_579153, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579153, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579153, "fields", newJString(fields))
  result = call_579151.call(path_579152, query_579153, nil, nil, nil)

var storageDefaultObjectAccessControlsList* = Call_StorageDefaultObjectAccessControlsList_579135(
    name: "storageDefaultObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsList_579136,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsList_579137,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsUpdate_579191 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsUpdate_579193(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsUpdate_579192(path: JsonNode;
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
  var valid_579194 = path.getOrDefault("bucket")
  valid_579194 = validateParameter(valid_579194, JString, required = true,
                                 default = nil)
  if valid_579194 != nil:
    section.add "bucket", valid_579194
  var valid_579195 = path.getOrDefault("entity")
  valid_579195 = validateParameter(valid_579195, JString, required = true,
                                 default = nil)
  if valid_579195 != nil:
    section.add "entity", valid_579195
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579196 = query.getOrDefault("key")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "key", valid_579196
  var valid_579197 = query.getOrDefault("prettyPrint")
  valid_579197 = validateParameter(valid_579197, JBool, required = false,
                                 default = newJBool(true))
  if valid_579197 != nil:
    section.add "prettyPrint", valid_579197
  var valid_579198 = query.getOrDefault("oauth_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "oauth_token", valid_579198
  var valid_579199 = query.getOrDefault("userProject")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "userProject", valid_579199
  var valid_579200 = query.getOrDefault("alt")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = newJString("json"))
  if valid_579200 != nil:
    section.add "alt", valid_579200
  var valid_579201 = query.getOrDefault("userIp")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "userIp", valid_579201
  var valid_579202 = query.getOrDefault("quotaUser")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "quotaUser", valid_579202
  var valid_579203 = query.getOrDefault("provisionalUserProject")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "provisionalUserProject", valid_579203
  var valid_579204 = query.getOrDefault("fields")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "fields", valid_579204
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

proc call*(call_579206: Call_StorageDefaultObjectAccessControlsUpdate_579191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket.
  ## 
  let valid = call_579206.validator(path, query, header, formData, body)
  let scheme = call_579206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579206.url(scheme.get, call_579206.host, call_579206.base,
                         call_579206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579206, url, valid)

proc call*(call_579207: Call_StorageDefaultObjectAccessControlsUpdate_579191;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsUpdate
  ## Updates a default object ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579208 = newJObject()
  var query_579209 = newJObject()
  var body_579210 = newJObject()
  add(query_579209, "key", newJString(key))
  add(query_579209, "prettyPrint", newJBool(prettyPrint))
  add(query_579209, "oauth_token", newJString(oauthToken))
  add(query_579209, "userProject", newJString(userProject))
  add(query_579209, "alt", newJString(alt))
  add(query_579209, "userIp", newJString(userIp))
  add(query_579209, "quotaUser", newJString(quotaUser))
  add(path_579208, "bucket", newJString(bucket))
  if body != nil:
    body_579210 = body
  add(query_579209, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579208, "entity", newJString(entity))
  add(query_579209, "fields", newJString(fields))
  result = call_579207.call(path_579208, query_579209, nil, nil, body_579210)

var storageDefaultObjectAccessControlsUpdate* = Call_StorageDefaultObjectAccessControlsUpdate_579191(
    name: "storageDefaultObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsUpdate_579192,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsUpdate_579193,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsGet_579173 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsGet_579175(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsGet_579174(path: JsonNode;
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
  var valid_579176 = path.getOrDefault("bucket")
  valid_579176 = validateParameter(valid_579176, JString, required = true,
                                 default = nil)
  if valid_579176 != nil:
    section.add "bucket", valid_579176
  var valid_579177 = path.getOrDefault("entity")
  valid_579177 = validateParameter(valid_579177, JString, required = true,
                                 default = nil)
  if valid_579177 != nil:
    section.add "entity", valid_579177
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579178 = query.getOrDefault("key")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "key", valid_579178
  var valid_579179 = query.getOrDefault("prettyPrint")
  valid_579179 = validateParameter(valid_579179, JBool, required = false,
                                 default = newJBool(true))
  if valid_579179 != nil:
    section.add "prettyPrint", valid_579179
  var valid_579180 = query.getOrDefault("oauth_token")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "oauth_token", valid_579180
  var valid_579181 = query.getOrDefault("userProject")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "userProject", valid_579181
  var valid_579182 = query.getOrDefault("alt")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = newJString("json"))
  if valid_579182 != nil:
    section.add "alt", valid_579182
  var valid_579183 = query.getOrDefault("userIp")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "userIp", valid_579183
  var valid_579184 = query.getOrDefault("quotaUser")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "quotaUser", valid_579184
  var valid_579185 = query.getOrDefault("provisionalUserProject")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "provisionalUserProject", valid_579185
  var valid_579186 = query.getOrDefault("fields")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "fields", valid_579186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579187: Call_StorageDefaultObjectAccessControlsGet_579173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_579187.validator(path, query, header, formData, body)
  let scheme = call_579187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579187.url(scheme.get, call_579187.host, call_579187.base,
                         call_579187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579187, url, valid)

proc call*(call_579188: Call_StorageDefaultObjectAccessControlsGet_579173;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsGet
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579189 = newJObject()
  var query_579190 = newJObject()
  add(query_579190, "key", newJString(key))
  add(query_579190, "prettyPrint", newJBool(prettyPrint))
  add(query_579190, "oauth_token", newJString(oauthToken))
  add(query_579190, "userProject", newJString(userProject))
  add(query_579190, "alt", newJString(alt))
  add(query_579190, "userIp", newJString(userIp))
  add(query_579190, "quotaUser", newJString(quotaUser))
  add(path_579189, "bucket", newJString(bucket))
  add(query_579190, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579189, "entity", newJString(entity))
  add(query_579190, "fields", newJString(fields))
  result = call_579188.call(path_579189, query_579190, nil, nil, nil)

var storageDefaultObjectAccessControlsGet* = Call_StorageDefaultObjectAccessControlsGet_579173(
    name: "storageDefaultObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsGet_579174,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsGet_579175,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsPatch_579229 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsPatch_579231(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsPatch_579230(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches a default object ACL entry on the specified bucket.
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
  var valid_579232 = path.getOrDefault("bucket")
  valid_579232 = validateParameter(valid_579232, JString, required = true,
                                 default = nil)
  if valid_579232 != nil:
    section.add "bucket", valid_579232
  var valid_579233 = path.getOrDefault("entity")
  valid_579233 = validateParameter(valid_579233, JString, required = true,
                                 default = nil)
  if valid_579233 != nil:
    section.add "entity", valid_579233
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579234 = query.getOrDefault("key")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "key", valid_579234
  var valid_579235 = query.getOrDefault("prettyPrint")
  valid_579235 = validateParameter(valid_579235, JBool, required = false,
                                 default = newJBool(true))
  if valid_579235 != nil:
    section.add "prettyPrint", valid_579235
  var valid_579236 = query.getOrDefault("oauth_token")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "oauth_token", valid_579236
  var valid_579237 = query.getOrDefault("userProject")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "userProject", valid_579237
  var valid_579238 = query.getOrDefault("alt")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = newJString("json"))
  if valid_579238 != nil:
    section.add "alt", valid_579238
  var valid_579239 = query.getOrDefault("userIp")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "userIp", valid_579239
  var valid_579240 = query.getOrDefault("quotaUser")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "quotaUser", valid_579240
  var valid_579241 = query.getOrDefault("provisionalUserProject")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "provisionalUserProject", valid_579241
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

proc call*(call_579244: Call_StorageDefaultObjectAccessControlsPatch_579229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches a default object ACL entry on the specified bucket.
  ## 
  let valid = call_579244.validator(path, query, header, formData, body)
  let scheme = call_579244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579244.url(scheme.get, call_579244.host, call_579244.base,
                         call_579244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579244, url, valid)

proc call*(call_579245: Call_StorageDefaultObjectAccessControlsPatch_579229;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsPatch
  ## Patches a default object ACL entry on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579246 = newJObject()
  var query_579247 = newJObject()
  var body_579248 = newJObject()
  add(query_579247, "key", newJString(key))
  add(query_579247, "prettyPrint", newJBool(prettyPrint))
  add(query_579247, "oauth_token", newJString(oauthToken))
  add(query_579247, "userProject", newJString(userProject))
  add(query_579247, "alt", newJString(alt))
  add(query_579247, "userIp", newJString(userIp))
  add(query_579247, "quotaUser", newJString(quotaUser))
  add(path_579246, "bucket", newJString(bucket))
  if body != nil:
    body_579248 = body
  add(query_579247, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579246, "entity", newJString(entity))
  add(query_579247, "fields", newJString(fields))
  result = call_579245.call(path_579246, query_579247, nil, nil, body_579248)

var storageDefaultObjectAccessControlsPatch* = Call_StorageDefaultObjectAccessControlsPatch_579229(
    name: "storageDefaultObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsPatch_579230,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsPatch_579231,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsDelete_579211 = ref object of OpenApiRestCall_578355
proc url_StorageDefaultObjectAccessControlsDelete_579213(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsDelete_579212(path: JsonNode;
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
  var valid_579214 = path.getOrDefault("bucket")
  valid_579214 = validateParameter(valid_579214, JString, required = true,
                                 default = nil)
  if valid_579214 != nil:
    section.add "bucket", valid_579214
  var valid_579215 = path.getOrDefault("entity")
  valid_579215 = validateParameter(valid_579215, JString, required = true,
                                 default = nil)
  if valid_579215 != nil:
    section.add "entity", valid_579215
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579216 = query.getOrDefault("key")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "key", valid_579216
  var valid_579217 = query.getOrDefault("prettyPrint")
  valid_579217 = validateParameter(valid_579217, JBool, required = false,
                                 default = newJBool(true))
  if valid_579217 != nil:
    section.add "prettyPrint", valid_579217
  var valid_579218 = query.getOrDefault("oauth_token")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "oauth_token", valid_579218
  var valid_579219 = query.getOrDefault("userProject")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "userProject", valid_579219
  var valid_579220 = query.getOrDefault("alt")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = newJString("json"))
  if valid_579220 != nil:
    section.add "alt", valid_579220
  var valid_579221 = query.getOrDefault("userIp")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "userIp", valid_579221
  var valid_579222 = query.getOrDefault("quotaUser")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "quotaUser", valid_579222
  var valid_579223 = query.getOrDefault("provisionalUserProject")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "provisionalUserProject", valid_579223
  var valid_579224 = query.getOrDefault("fields")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "fields", valid_579224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579225: Call_StorageDefaultObjectAccessControlsDelete_579211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_579225.validator(path, query, header, formData, body)
  let scheme = call_579225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579225.url(scheme.get, call_579225.host, call_579225.base,
                         call_579225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579225, url, valid)

proc call*(call_579226: Call_StorageDefaultObjectAccessControlsDelete_579211;
          bucket: string; entity: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsDelete
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579227 = newJObject()
  var query_579228 = newJObject()
  add(query_579228, "key", newJString(key))
  add(query_579228, "prettyPrint", newJBool(prettyPrint))
  add(query_579228, "oauth_token", newJString(oauthToken))
  add(query_579228, "userProject", newJString(userProject))
  add(query_579228, "alt", newJString(alt))
  add(query_579228, "userIp", newJString(userIp))
  add(query_579228, "quotaUser", newJString(quotaUser))
  add(path_579227, "bucket", newJString(bucket))
  add(query_579228, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579227, "entity", newJString(entity))
  add(query_579228, "fields", newJString(fields))
  result = call_579226.call(path_579227, query_579228, nil, nil, nil)

var storageDefaultObjectAccessControlsDelete* = Call_StorageDefaultObjectAccessControlsDelete_579211(
    name: "storageDefaultObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsDelete_579212,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsDelete_579213,
    schemes: {Scheme.Https})
type
  Call_StorageBucketsSetIamPolicy_579267 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsSetIamPolicy_579269(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsSetIamPolicy_579268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an IAM policy for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579270 = path.getOrDefault("bucket")
  valid_579270 = validateParameter(valid_579270, JString, required = true,
                                 default = nil)
  if valid_579270 != nil:
    section.add "bucket", valid_579270
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579271 = query.getOrDefault("key")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "key", valid_579271
  var valid_579272 = query.getOrDefault("prettyPrint")
  valid_579272 = validateParameter(valid_579272, JBool, required = false,
                                 default = newJBool(true))
  if valid_579272 != nil:
    section.add "prettyPrint", valid_579272
  var valid_579273 = query.getOrDefault("oauth_token")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "oauth_token", valid_579273
  var valid_579274 = query.getOrDefault("userProject")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "userProject", valid_579274
  var valid_579275 = query.getOrDefault("alt")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = newJString("json"))
  if valid_579275 != nil:
    section.add "alt", valid_579275
  var valid_579276 = query.getOrDefault("userIp")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "userIp", valid_579276
  var valid_579277 = query.getOrDefault("quotaUser")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "quotaUser", valid_579277
  var valid_579278 = query.getOrDefault("provisionalUserProject")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "provisionalUserProject", valid_579278
  var valid_579279 = query.getOrDefault("fields")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "fields", valid_579279
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

proc call*(call_579281: Call_StorageBucketsSetIamPolicy_579267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an IAM policy for the specified bucket.
  ## 
  let valid = call_579281.validator(path, query, header, formData, body)
  let scheme = call_579281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579281.url(scheme.get, call_579281.host, call_579281.base,
                         call_579281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579281, url, valid)

proc call*(call_579282: Call_StorageBucketsSetIamPolicy_579267; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketsSetIamPolicy
  ## Updates an IAM policy for the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579283 = newJObject()
  var query_579284 = newJObject()
  var body_579285 = newJObject()
  add(query_579284, "key", newJString(key))
  add(query_579284, "prettyPrint", newJBool(prettyPrint))
  add(query_579284, "oauth_token", newJString(oauthToken))
  add(query_579284, "userProject", newJString(userProject))
  add(query_579284, "alt", newJString(alt))
  add(query_579284, "userIp", newJString(userIp))
  add(query_579284, "quotaUser", newJString(quotaUser))
  add(path_579283, "bucket", newJString(bucket))
  if body != nil:
    body_579285 = body
  add(query_579284, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579284, "fields", newJString(fields))
  result = call_579282.call(path_579283, query_579284, nil, nil, body_579285)

var storageBucketsSetIamPolicy* = Call_StorageBucketsSetIamPolicy_579267(
    name: "storageBucketsSetIamPolicy", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/iam",
    validator: validate_StorageBucketsSetIamPolicy_579268, base: "/storage/v1",
    url: url_StorageBucketsSetIamPolicy_579269, schemes: {Scheme.Https})
type
  Call_StorageBucketsGetIamPolicy_579249 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsGetIamPolicy_579251(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsGetIamPolicy_579250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an IAM policy for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   optionsRequestedPolicyVersion: JInt
  ##                                : The IAM policy format version to be returned. If the optionsRequestedPolicyVersion is for an older version that doesn't support part of the requested IAM policy, the request fails.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_579256 = query.getOrDefault("userProject")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "userProject", valid_579256
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
  var valid_579260 = query.getOrDefault("optionsRequestedPolicyVersion")
  valid_579260 = validateParameter(valid_579260, JInt, required = false, default = nil)
  if valid_579260 != nil:
    section.add "optionsRequestedPolicyVersion", valid_579260
  var valid_579261 = query.getOrDefault("provisionalUserProject")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "provisionalUserProject", valid_579261
  var valid_579262 = query.getOrDefault("fields")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "fields", valid_579262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579263: Call_StorageBucketsGetIamPolicy_579249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an IAM policy for the specified bucket.
  ## 
  let valid = call_579263.validator(path, query, header, formData, body)
  let scheme = call_579263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579263.url(scheme.get, call_579263.host, call_579263.base,
                         call_579263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579263, url, valid)

proc call*(call_579264: Call_StorageBucketsGetIamPolicy_579249; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; optionsRequestedPolicyVersion: int = 0;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketsGetIamPolicy
  ## Returns an IAM policy for the specified bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   optionsRequestedPolicyVersion: int
  ##                                : The IAM policy format version to be returned. If the optionsRequestedPolicyVersion is for an older version that doesn't support part of the requested IAM policy, the request fails.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579265 = newJObject()
  var query_579266 = newJObject()
  add(query_579266, "key", newJString(key))
  add(query_579266, "prettyPrint", newJBool(prettyPrint))
  add(query_579266, "oauth_token", newJString(oauthToken))
  add(query_579266, "userProject", newJString(userProject))
  add(query_579266, "alt", newJString(alt))
  add(query_579266, "userIp", newJString(userIp))
  add(query_579266, "quotaUser", newJString(quotaUser))
  add(query_579266, "optionsRequestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(path_579265, "bucket", newJString(bucket))
  add(query_579266, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579266, "fields", newJString(fields))
  result = call_579264.call(path_579265, query_579266, nil, nil, nil)

var storageBucketsGetIamPolicy* = Call_StorageBucketsGetIamPolicy_579249(
    name: "storageBucketsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/iam",
    validator: validate_StorageBucketsGetIamPolicy_579250, base: "/storage/v1",
    url: url_StorageBucketsGetIamPolicy_579251, schemes: {Scheme.Https})
type
  Call_StorageBucketsTestIamPermissions_579286 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsTestIamPermissions_579288(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam/testPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsTestIamPermissions_579287(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579289 = path.getOrDefault("bucket")
  valid_579289 = validateParameter(valid_579289, JString, required = true,
                                 default = nil)
  if valid_579289 != nil:
    section.add "bucket", valid_579289
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579290 = query.getOrDefault("key")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "key", valid_579290
  var valid_579291 = query.getOrDefault("prettyPrint")
  valid_579291 = validateParameter(valid_579291, JBool, required = false,
                                 default = newJBool(true))
  if valid_579291 != nil:
    section.add "prettyPrint", valid_579291
  var valid_579292 = query.getOrDefault("oauth_token")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "oauth_token", valid_579292
  var valid_579293 = query.getOrDefault("userProject")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "userProject", valid_579293
  assert query != nil,
        "query argument is necessary due to required `permissions` field"
  var valid_579294 = query.getOrDefault("permissions")
  valid_579294 = validateParameter(valid_579294, JArray, required = true, default = nil)
  if valid_579294 != nil:
    section.add "permissions", valid_579294
  var valid_579295 = query.getOrDefault("alt")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = newJString("json"))
  if valid_579295 != nil:
    section.add "alt", valid_579295
  var valid_579296 = query.getOrDefault("userIp")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "userIp", valid_579296
  var valid_579297 = query.getOrDefault("quotaUser")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "quotaUser", valid_579297
  var valid_579298 = query.getOrDefault("provisionalUserProject")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "provisionalUserProject", valid_579298
  var valid_579299 = query.getOrDefault("fields")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "fields", valid_579299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579300: Call_StorageBucketsTestIamPermissions_579286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ## 
  let valid = call_579300.validator(path, query, header, formData, body)
  let scheme = call_579300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579300.url(scheme.get, call_579300.host, call_579300.base,
                         call_579300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579300, url, valid)

proc call*(call_579301: Call_StorageBucketsTestIamPermissions_579286;
          permissions: JsonNode; bucket: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketsTestIamPermissions
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579302 = newJObject()
  var query_579303 = newJObject()
  add(query_579303, "key", newJString(key))
  add(query_579303, "prettyPrint", newJBool(prettyPrint))
  add(query_579303, "oauth_token", newJString(oauthToken))
  add(query_579303, "userProject", newJString(userProject))
  if permissions != nil:
    query_579303.add "permissions", permissions
  add(query_579303, "alt", newJString(alt))
  add(query_579303, "userIp", newJString(userIp))
  add(query_579303, "quotaUser", newJString(quotaUser))
  add(path_579302, "bucket", newJString(bucket))
  add(query_579303, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579303, "fields", newJString(fields))
  result = call_579301.call(path_579302, query_579303, nil, nil, nil)

var storageBucketsTestIamPermissions* = Call_StorageBucketsTestIamPermissions_579286(
    name: "storageBucketsTestIamPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/iam/testPermissions",
    validator: validate_StorageBucketsTestIamPermissions_579287,
    base: "/storage/v1", url: url_StorageBucketsTestIamPermissions_579288,
    schemes: {Scheme.Https})
type
  Call_StorageBucketsLockRetentionPolicy_579304 = ref object of OpenApiRestCall_578355
proc url_StorageBucketsLockRetentionPolicy_579306(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/lockRetentionPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsLockRetentionPolicy_579305(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Locks retention policy on a bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579307 = path.getOrDefault("bucket")
  valid_579307 = validateParameter(valid_579307, JString, required = true,
                                 default = nil)
  if valid_579307 != nil:
    section.add "bucket", valid_579307
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString (required)
  ##                        : Makes the operation conditional on whether bucket's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579308 = query.getOrDefault("key")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "key", valid_579308
  var valid_579309 = query.getOrDefault("prettyPrint")
  valid_579309 = validateParameter(valid_579309, JBool, required = false,
                                 default = newJBool(true))
  if valid_579309 != nil:
    section.add "prettyPrint", valid_579309
  var valid_579310 = query.getOrDefault("oauth_token")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "oauth_token", valid_579310
  var valid_579311 = query.getOrDefault("userProject")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "userProject", valid_579311
  var valid_579312 = query.getOrDefault("alt")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = newJString("json"))
  if valid_579312 != nil:
    section.add "alt", valid_579312
  var valid_579313 = query.getOrDefault("userIp")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "userIp", valid_579313
  var valid_579314 = query.getOrDefault("quotaUser")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "quotaUser", valid_579314
  assert query != nil, "query argument is necessary due to required `ifMetagenerationMatch` field"
  var valid_579315 = query.getOrDefault("ifMetagenerationMatch")
  valid_579315 = validateParameter(valid_579315, JString, required = true,
                                 default = nil)
  if valid_579315 != nil:
    section.add "ifMetagenerationMatch", valid_579315
  var valid_579316 = query.getOrDefault("provisionalUserProject")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "provisionalUserProject", valid_579316
  var valid_579317 = query.getOrDefault("fields")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "fields", valid_579317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579318: Call_StorageBucketsLockRetentionPolicy_579304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Locks retention policy on a bucket.
  ## 
  let valid = call_579318.validator(path, query, header, formData, body)
  let scheme = call_579318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579318.url(scheme.get, call_579318.host, call_579318.base,
                         call_579318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579318, url, valid)

proc call*(call_579319: Call_StorageBucketsLockRetentionPolicy_579304;
          ifMetagenerationMatch: string; bucket: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageBucketsLockRetentionPolicy
  ## Locks retention policy on a bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string (required)
  ##                        : Makes the operation conditional on whether bucket's current metageneration matches the given value.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579320 = newJObject()
  var query_579321 = newJObject()
  add(query_579321, "key", newJString(key))
  add(query_579321, "prettyPrint", newJBool(prettyPrint))
  add(query_579321, "oauth_token", newJString(oauthToken))
  add(query_579321, "userProject", newJString(userProject))
  add(query_579321, "alt", newJString(alt))
  add(query_579321, "userIp", newJString(userIp))
  add(query_579321, "quotaUser", newJString(quotaUser))
  add(query_579321, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579320, "bucket", newJString(bucket))
  add(query_579321, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579321, "fields", newJString(fields))
  result = call_579319.call(path_579320, query_579321, nil, nil, nil)

var storageBucketsLockRetentionPolicy* = Call_StorageBucketsLockRetentionPolicy_579304(
    name: "storageBucketsLockRetentionPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/lockRetentionPolicy",
    validator: validate_StorageBucketsLockRetentionPolicy_579305,
    base: "/storage/v1", url: url_StorageBucketsLockRetentionPolicy_579306,
    schemes: {Scheme.Https})
type
  Call_StorageNotificationsInsert_579339 = ref object of OpenApiRestCall_578355
proc url_StorageNotificationsInsert_579341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsInsert_579340(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a notification subscription for a given bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579342 = path.getOrDefault("bucket")
  valid_579342 = validateParameter(valid_579342, JString, required = true,
                                 default = nil)
  if valid_579342 != nil:
    section.add "bucket", valid_579342
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579343 = query.getOrDefault("key")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "key", valid_579343
  var valid_579344 = query.getOrDefault("prettyPrint")
  valid_579344 = validateParameter(valid_579344, JBool, required = false,
                                 default = newJBool(true))
  if valid_579344 != nil:
    section.add "prettyPrint", valid_579344
  var valid_579345 = query.getOrDefault("oauth_token")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "oauth_token", valid_579345
  var valid_579346 = query.getOrDefault("userProject")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "userProject", valid_579346
  var valid_579347 = query.getOrDefault("alt")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = newJString("json"))
  if valid_579347 != nil:
    section.add "alt", valid_579347
  var valid_579348 = query.getOrDefault("userIp")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "userIp", valid_579348
  var valid_579349 = query.getOrDefault("quotaUser")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "quotaUser", valid_579349
  var valid_579350 = query.getOrDefault("provisionalUserProject")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "provisionalUserProject", valid_579350
  var valid_579351 = query.getOrDefault("fields")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "fields", valid_579351
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

proc call*(call_579353: Call_StorageNotificationsInsert_579339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a notification subscription for a given bucket.
  ## 
  let valid = call_579353.validator(path, query, header, formData, body)
  let scheme = call_579353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579353.url(scheme.get, call_579353.host, call_579353.base,
                         call_579353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579353, url, valid)

proc call*(call_579354: Call_StorageNotificationsInsert_579339; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageNotificationsInsert
  ## Creates a notification subscription for a given bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579355 = newJObject()
  var query_579356 = newJObject()
  var body_579357 = newJObject()
  add(query_579356, "key", newJString(key))
  add(query_579356, "prettyPrint", newJBool(prettyPrint))
  add(query_579356, "oauth_token", newJString(oauthToken))
  add(query_579356, "userProject", newJString(userProject))
  add(query_579356, "alt", newJString(alt))
  add(query_579356, "userIp", newJString(userIp))
  add(query_579356, "quotaUser", newJString(quotaUser))
  add(path_579355, "bucket", newJString(bucket))
  if body != nil:
    body_579357 = body
  add(query_579356, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579356, "fields", newJString(fields))
  result = call_579354.call(path_579355, query_579356, nil, nil, body_579357)

var storageNotificationsInsert* = Call_StorageNotificationsInsert_579339(
    name: "storageNotificationsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/notificationConfigs",
    validator: validate_StorageNotificationsInsert_579340, base: "/storage/v1",
    url: url_StorageNotificationsInsert_579341, schemes: {Scheme.Https})
type
  Call_StorageNotificationsList_579322 = ref object of OpenApiRestCall_578355
proc url_StorageNotificationsList_579324(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsList_579323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of notification subscriptions for a given bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a Google Cloud Storage bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579325 = path.getOrDefault("bucket")
  valid_579325 = validateParameter(valid_579325, JString, required = true,
                                 default = nil)
  if valid_579325 != nil:
    section.add "bucket", valid_579325
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579326 = query.getOrDefault("key")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "key", valid_579326
  var valid_579327 = query.getOrDefault("prettyPrint")
  valid_579327 = validateParameter(valid_579327, JBool, required = false,
                                 default = newJBool(true))
  if valid_579327 != nil:
    section.add "prettyPrint", valid_579327
  var valid_579328 = query.getOrDefault("oauth_token")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "oauth_token", valid_579328
  var valid_579329 = query.getOrDefault("userProject")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = nil)
  if valid_579329 != nil:
    section.add "userProject", valid_579329
  var valid_579330 = query.getOrDefault("alt")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = newJString("json"))
  if valid_579330 != nil:
    section.add "alt", valid_579330
  var valid_579331 = query.getOrDefault("userIp")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "userIp", valid_579331
  var valid_579332 = query.getOrDefault("quotaUser")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "quotaUser", valid_579332
  var valid_579333 = query.getOrDefault("provisionalUserProject")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "provisionalUserProject", valid_579333
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

proc call*(call_579335: Call_StorageNotificationsList_579322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of notification subscriptions for a given bucket.
  ## 
  let valid = call_579335.validator(path, query, header, formData, body)
  let scheme = call_579335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579335.url(scheme.get, call_579335.host, call_579335.base,
                         call_579335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579335, url, valid)

proc call*(call_579336: Call_StorageNotificationsList_579322; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; provisionalUserProject: string = "";
          fields: string = ""): Recallable =
  ## storageNotificationsList
  ## Retrieves a list of notification subscriptions for a given bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a Google Cloud Storage bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579337 = newJObject()
  var query_579338 = newJObject()
  add(query_579338, "key", newJString(key))
  add(query_579338, "prettyPrint", newJBool(prettyPrint))
  add(query_579338, "oauth_token", newJString(oauthToken))
  add(query_579338, "userProject", newJString(userProject))
  add(query_579338, "alt", newJString(alt))
  add(query_579338, "userIp", newJString(userIp))
  add(query_579338, "quotaUser", newJString(quotaUser))
  add(path_579337, "bucket", newJString(bucket))
  add(query_579338, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579338, "fields", newJString(fields))
  result = call_579336.call(path_579337, query_579338, nil, nil, nil)

var storageNotificationsList* = Call_StorageNotificationsList_579322(
    name: "storageNotificationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/notificationConfigs",
    validator: validate_StorageNotificationsList_579323, base: "/storage/v1",
    url: url_StorageNotificationsList_579324, schemes: {Scheme.Https})
type
  Call_StorageNotificationsGet_579358 = ref object of OpenApiRestCall_578355
proc url_StorageNotificationsGet_579360(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "notification" in path, "`notification` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs/"),
               (kind: VariableSegment, value: "notification")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsGet_579359(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## View a notification configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   notification: JString (required)
  ##               : Notification ID
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `notification` field"
  var valid_579361 = path.getOrDefault("notification")
  valid_579361 = validateParameter(valid_579361, JString, required = true,
                                 default = nil)
  if valid_579361 != nil:
    section.add "notification", valid_579361
  var valid_579362 = path.getOrDefault("bucket")
  valid_579362 = validateParameter(valid_579362, JString, required = true,
                                 default = nil)
  if valid_579362 != nil:
    section.add "bucket", valid_579362
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579363 = query.getOrDefault("key")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "key", valid_579363
  var valid_579364 = query.getOrDefault("prettyPrint")
  valid_579364 = validateParameter(valid_579364, JBool, required = false,
                                 default = newJBool(true))
  if valid_579364 != nil:
    section.add "prettyPrint", valid_579364
  var valid_579365 = query.getOrDefault("oauth_token")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "oauth_token", valid_579365
  var valid_579366 = query.getOrDefault("userProject")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "userProject", valid_579366
  var valid_579367 = query.getOrDefault("alt")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = newJString("json"))
  if valid_579367 != nil:
    section.add "alt", valid_579367
  var valid_579368 = query.getOrDefault("userIp")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "userIp", valid_579368
  var valid_579369 = query.getOrDefault("quotaUser")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "quotaUser", valid_579369
  var valid_579370 = query.getOrDefault("provisionalUserProject")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "provisionalUserProject", valid_579370
  var valid_579371 = query.getOrDefault("fields")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "fields", valid_579371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579372: Call_StorageNotificationsGet_579358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## View a notification configuration.
  ## 
  let valid = call_579372.validator(path, query, header, formData, body)
  let scheme = call_579372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579372.url(scheme.get, call_579372.host, call_579372.base,
                         call_579372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579372, url, valid)

proc call*(call_579373: Call_StorageNotificationsGet_579358; notification: string;
          bucket: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageNotificationsGet
  ## View a notification configuration.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   notification: string (required)
  ##               : Notification ID
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579374 = newJObject()
  var query_579375 = newJObject()
  add(query_579375, "key", newJString(key))
  add(query_579375, "prettyPrint", newJBool(prettyPrint))
  add(query_579375, "oauth_token", newJString(oauthToken))
  add(query_579375, "userProject", newJString(userProject))
  add(path_579374, "notification", newJString(notification))
  add(query_579375, "alt", newJString(alt))
  add(query_579375, "userIp", newJString(userIp))
  add(query_579375, "quotaUser", newJString(quotaUser))
  add(path_579374, "bucket", newJString(bucket))
  add(query_579375, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579375, "fields", newJString(fields))
  result = call_579373.call(path_579374, query_579375, nil, nil, nil)

var storageNotificationsGet* = Call_StorageNotificationsGet_579358(
    name: "storageNotificationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/b/{bucket}/notificationConfigs/{notification}",
    validator: validate_StorageNotificationsGet_579359, base: "/storage/v1",
    url: url_StorageNotificationsGet_579360, schemes: {Scheme.Https})
type
  Call_StorageNotificationsDelete_579376 = ref object of OpenApiRestCall_578355
proc url_StorageNotificationsDelete_579378(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "notification" in path, "`notification` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs/"),
               (kind: VariableSegment, value: "notification")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsDelete_579377(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes a notification subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   notification: JString (required)
  ##               : ID of the notification to delete.
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `notification` field"
  var valid_579379 = path.getOrDefault("notification")
  valid_579379 = validateParameter(valid_579379, JString, required = true,
                                 default = nil)
  if valid_579379 != nil:
    section.add "notification", valid_579379
  var valid_579380 = path.getOrDefault("bucket")
  valid_579380 = validateParameter(valid_579380, JString, required = true,
                                 default = nil)
  if valid_579380 != nil:
    section.add "bucket", valid_579380
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579381 = query.getOrDefault("key")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "key", valid_579381
  var valid_579382 = query.getOrDefault("prettyPrint")
  valid_579382 = validateParameter(valid_579382, JBool, required = false,
                                 default = newJBool(true))
  if valid_579382 != nil:
    section.add "prettyPrint", valid_579382
  var valid_579383 = query.getOrDefault("oauth_token")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "oauth_token", valid_579383
  var valid_579384 = query.getOrDefault("userProject")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "userProject", valid_579384
  var valid_579385 = query.getOrDefault("alt")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = newJString("json"))
  if valid_579385 != nil:
    section.add "alt", valid_579385
  var valid_579386 = query.getOrDefault("userIp")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "userIp", valid_579386
  var valid_579387 = query.getOrDefault("quotaUser")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "quotaUser", valid_579387
  var valid_579388 = query.getOrDefault("provisionalUserProject")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "provisionalUserProject", valid_579388
  var valid_579389 = query.getOrDefault("fields")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "fields", valid_579389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579390: Call_StorageNotificationsDelete_579376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a notification subscription.
  ## 
  let valid = call_579390.validator(path, query, header, formData, body)
  let scheme = call_579390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579390.url(scheme.get, call_579390.host, call_579390.base,
                         call_579390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579390, url, valid)

proc call*(call_579391: Call_StorageNotificationsDelete_579376;
          notification: string; bucket: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageNotificationsDelete
  ## Permanently deletes a notification subscription.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   notification: string (required)
  ##               : ID of the notification to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579392 = newJObject()
  var query_579393 = newJObject()
  add(query_579393, "key", newJString(key))
  add(query_579393, "prettyPrint", newJBool(prettyPrint))
  add(query_579393, "oauth_token", newJString(oauthToken))
  add(query_579393, "userProject", newJString(userProject))
  add(path_579392, "notification", newJString(notification))
  add(query_579393, "alt", newJString(alt))
  add(query_579393, "userIp", newJString(userIp))
  add(query_579393, "quotaUser", newJString(quotaUser))
  add(path_579392, "bucket", newJString(bucket))
  add(query_579393, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579393, "fields", newJString(fields))
  result = call_579391.call(path_579392, query_579393, nil, nil, nil)

var storageNotificationsDelete* = Call_StorageNotificationsDelete_579376(
    name: "storageNotificationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/b/{bucket}/notificationConfigs/{notification}",
    validator: validate_StorageNotificationsDelete_579377, base: "/storage/v1",
    url: url_StorageNotificationsDelete_579378, schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_579418 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsInsert_579420(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsInsert_579419(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stores a new object and metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579421 = path.getOrDefault("bucket")
  valid_579421 = validateParameter(valid_579421, JString, required = true,
                                 default = nil)
  if valid_579421 != nil:
    section.add "bucket", valid_579421
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   kmsKeyName: JString
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   name: JString
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   contentEncoding: JString
  ##                  : If set, sets the contentEncoding property of the final object to this value. Setting this parameter is equivalent to setting the contentEncoding metadata property. This can be useful when uploading an object with uploadType=media to indicate the encoding of the content being uploaded.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579422 = query.getOrDefault("key")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "key", valid_579422
  var valid_579423 = query.getOrDefault("prettyPrint")
  valid_579423 = validateParameter(valid_579423, JBool, required = false,
                                 default = newJBool(true))
  if valid_579423 != nil:
    section.add "prettyPrint", valid_579423
  var valid_579424 = query.getOrDefault("oauth_token")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "oauth_token", valid_579424
  var valid_579425 = query.getOrDefault("kmsKeyName")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "kmsKeyName", valid_579425
  var valid_579426 = query.getOrDefault("name")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "name", valid_579426
  var valid_579427 = query.getOrDefault("userProject")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "userProject", valid_579427
  var valid_579428 = query.getOrDefault("predefinedAcl")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579428 != nil:
    section.add "predefinedAcl", valid_579428
  var valid_579429 = query.getOrDefault("ifGenerationMatch")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "ifGenerationMatch", valid_579429
  var valid_579430 = query.getOrDefault("ifGenerationNotMatch")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = nil)
  if valid_579430 != nil:
    section.add "ifGenerationNotMatch", valid_579430
  var valid_579431 = query.getOrDefault("alt")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = newJString("json"))
  if valid_579431 != nil:
    section.add "alt", valid_579431
  var valid_579432 = query.getOrDefault("userIp")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = nil)
  if valid_579432 != nil:
    section.add "userIp", valid_579432
  var valid_579433 = query.getOrDefault("quotaUser")
  valid_579433 = validateParameter(valid_579433, JString, required = false,
                                 default = nil)
  if valid_579433 != nil:
    section.add "quotaUser", valid_579433
  var valid_579434 = query.getOrDefault("ifMetagenerationMatch")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = nil)
  if valid_579434 != nil:
    section.add "ifMetagenerationMatch", valid_579434
  var valid_579435 = query.getOrDefault("contentEncoding")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "contentEncoding", valid_579435
  var valid_579436 = query.getOrDefault("provisionalUserProject")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "provisionalUserProject", valid_579436
  var valid_579437 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "ifMetagenerationNotMatch", valid_579437
  var valid_579438 = query.getOrDefault("projection")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = newJString("full"))
  if valid_579438 != nil:
    section.add "projection", valid_579438
  var valid_579439 = query.getOrDefault("fields")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "fields", valid_579439
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

proc call*(call_579441: Call_StorageObjectsInsert_579418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores a new object and metadata.
  ## 
  let valid = call_579441.validator(path, query, header, formData, body)
  let scheme = call_579441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579441.url(scheme.get, call_579441.host, call_579441.base,
                         call_579441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579441, url, valid)

proc call*(call_579442: Call_StorageObjectsInsert_579418; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          kmsKeyName: string = ""; name: string = ""; userProject: string = "";
          predefinedAcl: string = "authenticatedRead";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          contentEncoding: string = ""; provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsInsert
  ## Stores a new object and metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   kmsKeyName: string
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   name: string
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
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
  ##   contentEncoding: string
  ##                  : If set, sets the contentEncoding property of the final object to this value. Setting this parameter is equivalent to setting the contentEncoding metadata property. This can be useful when uploading an object with uploadType=media to indicate the encoding of the content being uploaded.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579443 = newJObject()
  var query_579444 = newJObject()
  var body_579445 = newJObject()
  add(query_579444, "key", newJString(key))
  add(query_579444, "prettyPrint", newJBool(prettyPrint))
  add(query_579444, "oauth_token", newJString(oauthToken))
  add(query_579444, "kmsKeyName", newJString(kmsKeyName))
  add(query_579444, "name", newJString(name))
  add(query_579444, "userProject", newJString(userProject))
  add(query_579444, "predefinedAcl", newJString(predefinedAcl))
  add(query_579444, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579444, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579444, "alt", newJString(alt))
  add(query_579444, "userIp", newJString(userIp))
  add(query_579444, "quotaUser", newJString(quotaUser))
  add(query_579444, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579443, "bucket", newJString(bucket))
  if body != nil:
    body_579445 = body
  add(query_579444, "contentEncoding", newJString(contentEncoding))
  add(query_579444, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579444, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579444, "projection", newJString(projection))
  add(query_579444, "fields", newJString(fields))
  result = call_579442.call(path_579443, query_579444, nil, nil, body_579445)

var storageObjectsInsert* = Call_StorageObjectsInsert_579418(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_579419, base: "/storage/v1",
    url: url_StorageObjectsInsert_579420, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_579394 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsList_579396(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsList_579395(path: JsonNode; query: JsonNode;
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
  var valid_579397 = path.getOrDefault("bucket")
  valid_579397 = validateParameter(valid_579397, JString, required = true,
                                 default = nil)
  if valid_579397 != nil:
    section.add "bucket", valid_579397
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
  ##   includeTrailingDelimiter: JBool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   versions: JBool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  section = newJObject()
  var valid_579398 = query.getOrDefault("key")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = nil)
  if valid_579398 != nil:
    section.add "key", valid_579398
  var valid_579399 = query.getOrDefault("prettyPrint")
  valid_579399 = validateParameter(valid_579399, JBool, required = false,
                                 default = newJBool(true))
  if valid_579399 != nil:
    section.add "prettyPrint", valid_579399
  var valid_579400 = query.getOrDefault("oauth_token")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "oauth_token", valid_579400
  var valid_579401 = query.getOrDefault("prefix")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "prefix", valid_579401
  var valid_579402 = query.getOrDefault("includeTrailingDelimiter")
  valid_579402 = validateParameter(valid_579402, JBool, required = false, default = nil)
  if valid_579402 != nil:
    section.add "includeTrailingDelimiter", valid_579402
  var valid_579403 = query.getOrDefault("userProject")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "userProject", valid_579403
  var valid_579404 = query.getOrDefault("alt")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = newJString("json"))
  if valid_579404 != nil:
    section.add "alt", valid_579404
  var valid_579405 = query.getOrDefault("userIp")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "userIp", valid_579405
  var valid_579406 = query.getOrDefault("quotaUser")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "quotaUser", valid_579406
  var valid_579407 = query.getOrDefault("pageToken")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "pageToken", valid_579407
  var valid_579408 = query.getOrDefault("provisionalUserProject")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "provisionalUserProject", valid_579408
  var valid_579409 = query.getOrDefault("projection")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = newJString("full"))
  if valid_579409 != nil:
    section.add "projection", valid_579409
  var valid_579410 = query.getOrDefault("fields")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "fields", valid_579410
  var valid_579411 = query.getOrDefault("delimiter")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "delimiter", valid_579411
  var valid_579412 = query.getOrDefault("maxResults")
  valid_579412 = validateParameter(valid_579412, JInt, required = false,
                                 default = newJInt(1000))
  if valid_579412 != nil:
    section.add "maxResults", valid_579412
  var valid_579413 = query.getOrDefault("versions")
  valid_579413 = validateParameter(valid_579413, JBool, required = false, default = nil)
  if valid_579413 != nil:
    section.add "versions", valid_579413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579414: Call_StorageObjectsList_579394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_579414.validator(path, query, header, formData, body)
  let scheme = call_579414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579414.url(scheme.get, call_579414.host, call_579414.base,
                         call_579414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579414, url, valid)

proc call*(call_579415: Call_StorageObjectsList_579394; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          prefix: string = ""; includeTrailingDelimiter: bool = false;
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = "";
          provisionalUserProject: string = ""; projection: string = "full";
          fields: string = ""; delimiter: string = ""; maxResults: int = 1000;
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
  ##   includeTrailingDelimiter: bool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   versions: bool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  var path_579416 = newJObject()
  var query_579417 = newJObject()
  add(query_579417, "key", newJString(key))
  add(query_579417, "prettyPrint", newJBool(prettyPrint))
  add(query_579417, "oauth_token", newJString(oauthToken))
  add(query_579417, "prefix", newJString(prefix))
  add(query_579417, "includeTrailingDelimiter", newJBool(includeTrailingDelimiter))
  add(query_579417, "userProject", newJString(userProject))
  add(query_579417, "alt", newJString(alt))
  add(query_579417, "userIp", newJString(userIp))
  add(query_579417, "quotaUser", newJString(quotaUser))
  add(query_579417, "pageToken", newJString(pageToken))
  add(path_579416, "bucket", newJString(bucket))
  add(query_579417, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579417, "projection", newJString(projection))
  add(query_579417, "fields", newJString(fields))
  add(query_579417, "delimiter", newJString(delimiter))
  add(query_579417, "maxResults", newJInt(maxResults))
  add(query_579417, "versions", newJBool(versions))
  result = call_579415.call(path_579416, query_579417, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_579394(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_579395, base: "/storage/v1",
    url: url_StorageObjectsList_579396, schemes: {Scheme.Https})
type
  Call_StorageObjectsWatchAll_579446 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsWatchAll_579448(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsWatchAll_579447(path: JsonNode; query: JsonNode;
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
  var valid_579449 = path.getOrDefault("bucket")
  valid_579449 = validateParameter(valid_579449, JString, required = true,
                                 default = nil)
  if valid_579449 != nil:
    section.add "bucket", valid_579449
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
  ##   includeTrailingDelimiter: JBool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   versions: JBool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  section = newJObject()
  var valid_579450 = query.getOrDefault("key")
  valid_579450 = validateParameter(valid_579450, JString, required = false,
                                 default = nil)
  if valid_579450 != nil:
    section.add "key", valid_579450
  var valid_579451 = query.getOrDefault("prettyPrint")
  valid_579451 = validateParameter(valid_579451, JBool, required = false,
                                 default = newJBool(true))
  if valid_579451 != nil:
    section.add "prettyPrint", valid_579451
  var valid_579452 = query.getOrDefault("oauth_token")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = nil)
  if valid_579452 != nil:
    section.add "oauth_token", valid_579452
  var valid_579453 = query.getOrDefault("prefix")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "prefix", valid_579453
  var valid_579454 = query.getOrDefault("includeTrailingDelimiter")
  valid_579454 = validateParameter(valid_579454, JBool, required = false, default = nil)
  if valid_579454 != nil:
    section.add "includeTrailingDelimiter", valid_579454
  var valid_579455 = query.getOrDefault("userProject")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = nil)
  if valid_579455 != nil:
    section.add "userProject", valid_579455
  var valid_579456 = query.getOrDefault("alt")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = newJString("json"))
  if valid_579456 != nil:
    section.add "alt", valid_579456
  var valid_579457 = query.getOrDefault("userIp")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "userIp", valid_579457
  var valid_579458 = query.getOrDefault("quotaUser")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "quotaUser", valid_579458
  var valid_579459 = query.getOrDefault("pageToken")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = nil)
  if valid_579459 != nil:
    section.add "pageToken", valid_579459
  var valid_579460 = query.getOrDefault("provisionalUserProject")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "provisionalUserProject", valid_579460
  var valid_579461 = query.getOrDefault("projection")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = newJString("full"))
  if valid_579461 != nil:
    section.add "projection", valid_579461
  var valid_579462 = query.getOrDefault("fields")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "fields", valid_579462
  var valid_579463 = query.getOrDefault("delimiter")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "delimiter", valid_579463
  var valid_579464 = query.getOrDefault("maxResults")
  valid_579464 = validateParameter(valid_579464, JInt, required = false,
                                 default = newJInt(1000))
  if valid_579464 != nil:
    section.add "maxResults", valid_579464
  var valid_579465 = query.getOrDefault("versions")
  valid_579465 = validateParameter(valid_579465, JBool, required = false, default = nil)
  if valid_579465 != nil:
    section.add "versions", valid_579465
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

proc call*(call_579467: Call_StorageObjectsWatchAll_579446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes on all objects in a bucket.
  ## 
  let valid = call_579467.validator(path, query, header, formData, body)
  let scheme = call_579467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579467.url(scheme.get, call_579467.host, call_579467.base,
                         call_579467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579467, url, valid)

proc call*(call_579468: Call_StorageObjectsWatchAll_579446; bucket: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          prefix: string = ""; includeTrailingDelimiter: bool = false;
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = "";
          provisionalUserProject: string = ""; resource: JsonNode = nil;
          projection: string = "full"; fields: string = ""; delimiter: string = "";
          maxResults: int = 1000; versions: bool = false): Recallable =
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
  ##   includeTrailingDelimiter: bool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   resource: JObject
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   versions: bool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  var path_579469 = newJObject()
  var query_579470 = newJObject()
  var body_579471 = newJObject()
  add(query_579470, "key", newJString(key))
  add(query_579470, "prettyPrint", newJBool(prettyPrint))
  add(query_579470, "oauth_token", newJString(oauthToken))
  add(query_579470, "prefix", newJString(prefix))
  add(query_579470, "includeTrailingDelimiter", newJBool(includeTrailingDelimiter))
  add(query_579470, "userProject", newJString(userProject))
  add(query_579470, "alt", newJString(alt))
  add(query_579470, "userIp", newJString(userIp))
  add(query_579470, "quotaUser", newJString(quotaUser))
  add(query_579470, "pageToken", newJString(pageToken))
  add(path_579469, "bucket", newJString(bucket))
  add(query_579470, "provisionalUserProject", newJString(provisionalUserProject))
  if resource != nil:
    body_579471 = resource
  add(query_579470, "projection", newJString(projection))
  add(query_579470, "fields", newJString(fields))
  add(query_579470, "delimiter", newJString(delimiter))
  add(query_579470, "maxResults", newJInt(maxResults))
  add(query_579470, "versions", newJBool(versions))
  result = call_579468.call(path_579469, query_579470, nil, nil, body_579471)

var storageObjectsWatchAll* = Call_StorageObjectsWatchAll_579446(
    name: "storageObjectsWatchAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/watch",
    validator: validate_StorageObjectsWatchAll_579447, base: "/storage/v1",
    url: url_StorageObjectsWatchAll_579448, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_579496 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsUpdate_579498(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsUpdate_579497(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an object's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579499 = path.getOrDefault("bucket")
  valid_579499 = validateParameter(valid_579499, JString, required = true,
                                 default = nil)
  if valid_579499 != nil:
    section.add "bucket", valid_579499
  var valid_579500 = path.getOrDefault("object")
  valid_579500 = validateParameter(valid_579500, JString, required = true,
                                 default = nil)
  if valid_579500 != nil:
    section.add "object", valid_579500
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579501 = query.getOrDefault("key")
  valid_579501 = validateParameter(valid_579501, JString, required = false,
                                 default = nil)
  if valid_579501 != nil:
    section.add "key", valid_579501
  var valid_579502 = query.getOrDefault("prettyPrint")
  valid_579502 = validateParameter(valid_579502, JBool, required = false,
                                 default = newJBool(true))
  if valid_579502 != nil:
    section.add "prettyPrint", valid_579502
  var valid_579503 = query.getOrDefault("oauth_token")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = nil)
  if valid_579503 != nil:
    section.add "oauth_token", valid_579503
  var valid_579504 = query.getOrDefault("generation")
  valid_579504 = validateParameter(valid_579504, JString, required = false,
                                 default = nil)
  if valid_579504 != nil:
    section.add "generation", valid_579504
  var valid_579505 = query.getOrDefault("userProject")
  valid_579505 = validateParameter(valid_579505, JString, required = false,
                                 default = nil)
  if valid_579505 != nil:
    section.add "userProject", valid_579505
  var valid_579506 = query.getOrDefault("predefinedAcl")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579506 != nil:
    section.add "predefinedAcl", valid_579506
  var valid_579507 = query.getOrDefault("ifGenerationMatch")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "ifGenerationMatch", valid_579507
  var valid_579508 = query.getOrDefault("ifGenerationNotMatch")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "ifGenerationNotMatch", valid_579508
  var valid_579509 = query.getOrDefault("alt")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = newJString("json"))
  if valid_579509 != nil:
    section.add "alt", valid_579509
  var valid_579510 = query.getOrDefault("userIp")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "userIp", valid_579510
  var valid_579511 = query.getOrDefault("quotaUser")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "quotaUser", valid_579511
  var valid_579512 = query.getOrDefault("ifMetagenerationMatch")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "ifMetagenerationMatch", valid_579512
  var valid_579513 = query.getOrDefault("provisionalUserProject")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "provisionalUserProject", valid_579513
  var valid_579514 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "ifMetagenerationNotMatch", valid_579514
  var valid_579515 = query.getOrDefault("projection")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = newJString("full"))
  if valid_579515 != nil:
    section.add "projection", valid_579515
  var valid_579516 = query.getOrDefault("fields")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "fields", valid_579516
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

proc call*(call_579518: Call_StorageObjectsUpdate_579496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an object's metadata.
  ## 
  let valid = call_579518.validator(path, query, header, formData, body)
  let scheme = call_579518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579518.url(scheme.get, call_579518.host, call_579518.base,
                         call_579518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579518, url, valid)

proc call*(call_579519: Call_StorageObjectsUpdate_579496; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          predefinedAcl: string = "authenticatedRead";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsUpdate
  ## Updates an object's metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579520 = newJObject()
  var query_579521 = newJObject()
  var body_579522 = newJObject()
  add(query_579521, "key", newJString(key))
  add(query_579521, "prettyPrint", newJBool(prettyPrint))
  add(query_579521, "oauth_token", newJString(oauthToken))
  add(query_579521, "generation", newJString(generation))
  add(query_579521, "userProject", newJString(userProject))
  add(query_579521, "predefinedAcl", newJString(predefinedAcl))
  add(query_579521, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579521, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579521, "alt", newJString(alt))
  add(query_579521, "userIp", newJString(userIp))
  add(query_579521, "quotaUser", newJString(quotaUser))
  add(query_579521, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579520, "bucket", newJString(bucket))
  if body != nil:
    body_579522 = body
  add(query_579521, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579520, "object", newJString(`object`))
  add(query_579521, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579521, "projection", newJString(projection))
  add(query_579521, "fields", newJString(fields))
  result = call_579519.call(path_579520, query_579521, nil, nil, body_579522)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_579496(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_579497, base: "/storage/v1",
    url: url_StorageObjectsUpdate_579498, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_579472 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsGet_579474(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsGet_579473(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves an object or its metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579475 = path.getOrDefault("bucket")
  valid_579475 = validateParameter(valid_579475, JString, required = true,
                                 default = nil)
  if valid_579475 != nil:
    section.add "bucket", valid_579475
  var valid_579476 = path.getOrDefault("object")
  valid_579476 = validateParameter(valid_579476, JString, required = true,
                                 default = nil)
  if valid_579476 != nil:
    section.add "object", valid_579476
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579477 = query.getOrDefault("key")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "key", valid_579477
  var valid_579478 = query.getOrDefault("prettyPrint")
  valid_579478 = validateParameter(valid_579478, JBool, required = false,
                                 default = newJBool(true))
  if valid_579478 != nil:
    section.add "prettyPrint", valid_579478
  var valid_579479 = query.getOrDefault("oauth_token")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "oauth_token", valid_579479
  var valid_579480 = query.getOrDefault("generation")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = nil)
  if valid_579480 != nil:
    section.add "generation", valid_579480
  var valid_579481 = query.getOrDefault("userProject")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "userProject", valid_579481
  var valid_579482 = query.getOrDefault("ifGenerationMatch")
  valid_579482 = validateParameter(valid_579482, JString, required = false,
                                 default = nil)
  if valid_579482 != nil:
    section.add "ifGenerationMatch", valid_579482
  var valid_579483 = query.getOrDefault("ifGenerationNotMatch")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "ifGenerationNotMatch", valid_579483
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
  var valid_579488 = query.getOrDefault("provisionalUserProject")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "provisionalUserProject", valid_579488
  var valid_579489 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = nil)
  if valid_579489 != nil:
    section.add "ifMetagenerationNotMatch", valid_579489
  var valid_579490 = query.getOrDefault("projection")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = newJString("full"))
  if valid_579490 != nil:
    section.add "projection", valid_579490
  var valid_579491 = query.getOrDefault("fields")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = nil)
  if valid_579491 != nil:
    section.add "fields", valid_579491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579492: Call_StorageObjectsGet_579472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an object or its metadata.
  ## 
  let valid = call_579492.validator(path, query, header, formData, body)
  let scheme = call_579492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579492.url(scheme.get, call_579492.host, call_579492.base,
                         call_579492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579492, url, valid)

proc call*(call_579493: Call_StorageObjectsGet_579472; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsGet
  ## Retrieves an object or its metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579494 = newJObject()
  var query_579495 = newJObject()
  add(query_579495, "key", newJString(key))
  add(query_579495, "prettyPrint", newJBool(prettyPrint))
  add(query_579495, "oauth_token", newJString(oauthToken))
  add(query_579495, "generation", newJString(generation))
  add(query_579495, "userProject", newJString(userProject))
  add(query_579495, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579495, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579495, "alt", newJString(alt))
  add(query_579495, "userIp", newJString(userIp))
  add(query_579495, "quotaUser", newJString(quotaUser))
  add(query_579495, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579494, "bucket", newJString(bucket))
  add(query_579495, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579494, "object", newJString(`object`))
  add(query_579495, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579495, "projection", newJString(projection))
  add(query_579495, "fields", newJString(fields))
  result = call_579493.call(path_579494, query_579495, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_579472(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_579473,
    base: "/storage/v1", url: url_StorageObjectsGet_579474, schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_579546 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsPatch_579548(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsPatch_579547(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patches an object's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579549 = path.getOrDefault("bucket")
  valid_579549 = validateParameter(valid_579549, JString, required = true,
                                 default = nil)
  if valid_579549 != nil:
    section.add "bucket", valid_579549
  var valid_579550 = path.getOrDefault("object")
  valid_579550 = validateParameter(valid_579550, JString, required = true,
                                 default = nil)
  if valid_579550 != nil:
    section.add "object", valid_579550
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
  ##   userProject: JString
  ##              : The project to be billed for this request, for Requester Pays buckets.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579551 = query.getOrDefault("key")
  valid_579551 = validateParameter(valid_579551, JString, required = false,
                                 default = nil)
  if valid_579551 != nil:
    section.add "key", valid_579551
  var valid_579552 = query.getOrDefault("prettyPrint")
  valid_579552 = validateParameter(valid_579552, JBool, required = false,
                                 default = newJBool(true))
  if valid_579552 != nil:
    section.add "prettyPrint", valid_579552
  var valid_579553 = query.getOrDefault("oauth_token")
  valid_579553 = validateParameter(valid_579553, JString, required = false,
                                 default = nil)
  if valid_579553 != nil:
    section.add "oauth_token", valid_579553
  var valid_579554 = query.getOrDefault("generation")
  valid_579554 = validateParameter(valid_579554, JString, required = false,
                                 default = nil)
  if valid_579554 != nil:
    section.add "generation", valid_579554
  var valid_579555 = query.getOrDefault("userProject")
  valid_579555 = validateParameter(valid_579555, JString, required = false,
                                 default = nil)
  if valid_579555 != nil:
    section.add "userProject", valid_579555
  var valid_579556 = query.getOrDefault("predefinedAcl")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579556 != nil:
    section.add "predefinedAcl", valid_579556
  var valid_579557 = query.getOrDefault("ifGenerationMatch")
  valid_579557 = validateParameter(valid_579557, JString, required = false,
                                 default = nil)
  if valid_579557 != nil:
    section.add "ifGenerationMatch", valid_579557
  var valid_579558 = query.getOrDefault("ifGenerationNotMatch")
  valid_579558 = validateParameter(valid_579558, JString, required = false,
                                 default = nil)
  if valid_579558 != nil:
    section.add "ifGenerationNotMatch", valid_579558
  var valid_579559 = query.getOrDefault("alt")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = newJString("json"))
  if valid_579559 != nil:
    section.add "alt", valid_579559
  var valid_579560 = query.getOrDefault("userIp")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = nil)
  if valid_579560 != nil:
    section.add "userIp", valid_579560
  var valid_579561 = query.getOrDefault("quotaUser")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "quotaUser", valid_579561
  var valid_579562 = query.getOrDefault("ifMetagenerationMatch")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = nil)
  if valid_579562 != nil:
    section.add "ifMetagenerationMatch", valid_579562
  var valid_579563 = query.getOrDefault("provisionalUserProject")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "provisionalUserProject", valid_579563
  var valid_579564 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = nil)
  if valid_579564 != nil:
    section.add "ifMetagenerationNotMatch", valid_579564
  var valid_579565 = query.getOrDefault("projection")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = newJString("full"))
  if valid_579565 != nil:
    section.add "projection", valid_579565
  var valid_579566 = query.getOrDefault("fields")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = nil)
  if valid_579566 != nil:
    section.add "fields", valid_579566
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

proc call*(call_579568: Call_StorageObjectsPatch_579546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches an object's metadata.
  ## 
  let valid = call_579568.validator(path, query, header, formData, body)
  let scheme = call_579568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579568.url(scheme.get, call_579568.host, call_579568.base,
                         call_579568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579568, url, valid)

proc call*(call_579569: Call_StorageObjectsPatch_579546; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          predefinedAcl: string = "authenticatedRead";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsPatch
  ## Patches an object's metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request, for Requester Pays buckets.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579570 = newJObject()
  var query_579571 = newJObject()
  var body_579572 = newJObject()
  add(query_579571, "key", newJString(key))
  add(query_579571, "prettyPrint", newJBool(prettyPrint))
  add(query_579571, "oauth_token", newJString(oauthToken))
  add(query_579571, "generation", newJString(generation))
  add(query_579571, "userProject", newJString(userProject))
  add(query_579571, "predefinedAcl", newJString(predefinedAcl))
  add(query_579571, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579571, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579571, "alt", newJString(alt))
  add(query_579571, "userIp", newJString(userIp))
  add(query_579571, "quotaUser", newJString(quotaUser))
  add(query_579571, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579570, "bucket", newJString(bucket))
  if body != nil:
    body_579572 = body
  add(query_579571, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579570, "object", newJString(`object`))
  add(query_579571, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579571, "projection", newJString(projection))
  add(query_579571, "fields", newJString(fields))
  result = call_579569.call(path_579570, query_579571, nil, nil, body_579572)

var storageObjectsPatch* = Call_StorageObjectsPatch_579546(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_579547, base: "/storage/v1",
    url: url_StorageObjectsPatch_579548, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_579523 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsDelete_579525(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsDelete_579524(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579526 = path.getOrDefault("bucket")
  valid_579526 = validateParameter(valid_579526, JString, required = true,
                                 default = nil)
  if valid_579526 != nil:
    section.add "bucket", valid_579526
  var valid_579527 = path.getOrDefault("object")
  valid_579527 = validateParameter(valid_579527, JString, required = true,
                                 default = nil)
  if valid_579527 != nil:
    section.add "object", valid_579527
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
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
  var valid_579531 = query.getOrDefault("generation")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "generation", valid_579531
  var valid_579532 = query.getOrDefault("userProject")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "userProject", valid_579532
  var valid_579533 = query.getOrDefault("ifGenerationMatch")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "ifGenerationMatch", valid_579533
  var valid_579534 = query.getOrDefault("ifGenerationNotMatch")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "ifGenerationNotMatch", valid_579534
  var valid_579535 = query.getOrDefault("alt")
  valid_579535 = validateParameter(valid_579535, JString, required = false,
                                 default = newJString("json"))
  if valid_579535 != nil:
    section.add "alt", valid_579535
  var valid_579536 = query.getOrDefault("userIp")
  valid_579536 = validateParameter(valid_579536, JString, required = false,
                                 default = nil)
  if valid_579536 != nil:
    section.add "userIp", valid_579536
  var valid_579537 = query.getOrDefault("quotaUser")
  valid_579537 = validateParameter(valid_579537, JString, required = false,
                                 default = nil)
  if valid_579537 != nil:
    section.add "quotaUser", valid_579537
  var valid_579538 = query.getOrDefault("ifMetagenerationMatch")
  valid_579538 = validateParameter(valid_579538, JString, required = false,
                                 default = nil)
  if valid_579538 != nil:
    section.add "ifMetagenerationMatch", valid_579538
  var valid_579539 = query.getOrDefault("provisionalUserProject")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "provisionalUserProject", valid_579539
  var valid_579540 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = nil)
  if valid_579540 != nil:
    section.add "ifMetagenerationNotMatch", valid_579540
  var valid_579541 = query.getOrDefault("fields")
  valid_579541 = validateParameter(valid_579541, JString, required = false,
                                 default = nil)
  if valid_579541 != nil:
    section.add "fields", valid_579541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579542: Call_StorageObjectsDelete_579523; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  let valid = call_579542.validator(path, query, header, formData, body)
  let scheme = call_579542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579542.url(scheme.get, call_579542.host, call_579542.base,
                         call_579542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579542, url, valid)

proc call*(call_579543: Call_StorageObjectsDelete_579523; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          ifGenerationMatch: string = ""; ifGenerationNotMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; fields: string = ""): Recallable =
  ## storageObjectsDelete
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, permanently deletes a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579544 = newJObject()
  var query_579545 = newJObject()
  add(query_579545, "key", newJString(key))
  add(query_579545, "prettyPrint", newJBool(prettyPrint))
  add(query_579545, "oauth_token", newJString(oauthToken))
  add(query_579545, "generation", newJString(generation))
  add(query_579545, "userProject", newJString(userProject))
  add(query_579545, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579545, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579545, "alt", newJString(alt))
  add(query_579545, "userIp", newJString(userIp))
  add(query_579545, "quotaUser", newJString(quotaUser))
  add(query_579545, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(path_579544, "bucket", newJString(bucket))
  add(query_579545, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579544, "object", newJString(`object`))
  add(query_579545, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579545, "fields", newJString(fields))
  result = call_579543.call(path_579544, query_579545, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_579523(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_579524, base: "/storage/v1",
    url: url_StorageObjectsDelete_579525, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_579592 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsInsert_579594(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsInsert_579593(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579595 = path.getOrDefault("bucket")
  valid_579595 = validateParameter(valid_579595, JString, required = true,
                                 default = nil)
  if valid_579595 != nil:
    section.add "bucket", valid_579595
  var valid_579596 = path.getOrDefault("object")
  valid_579596 = validateParameter(valid_579596, JString, required = true,
                                 default = nil)
  if valid_579596 != nil:
    section.add "object", valid_579596
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579597 = query.getOrDefault("key")
  valid_579597 = validateParameter(valid_579597, JString, required = false,
                                 default = nil)
  if valid_579597 != nil:
    section.add "key", valid_579597
  var valid_579598 = query.getOrDefault("prettyPrint")
  valid_579598 = validateParameter(valid_579598, JBool, required = false,
                                 default = newJBool(true))
  if valid_579598 != nil:
    section.add "prettyPrint", valid_579598
  var valid_579599 = query.getOrDefault("oauth_token")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = nil)
  if valid_579599 != nil:
    section.add "oauth_token", valid_579599
  var valid_579600 = query.getOrDefault("generation")
  valid_579600 = validateParameter(valid_579600, JString, required = false,
                                 default = nil)
  if valid_579600 != nil:
    section.add "generation", valid_579600
  var valid_579601 = query.getOrDefault("userProject")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "userProject", valid_579601
  var valid_579602 = query.getOrDefault("alt")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = newJString("json"))
  if valid_579602 != nil:
    section.add "alt", valid_579602
  var valid_579603 = query.getOrDefault("userIp")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = nil)
  if valid_579603 != nil:
    section.add "userIp", valid_579603
  var valid_579604 = query.getOrDefault("quotaUser")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = nil)
  if valid_579604 != nil:
    section.add "quotaUser", valid_579604
  var valid_579605 = query.getOrDefault("provisionalUserProject")
  valid_579605 = validateParameter(valid_579605, JString, required = false,
                                 default = nil)
  if valid_579605 != nil:
    section.add "provisionalUserProject", valid_579605
  var valid_579606 = query.getOrDefault("fields")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "fields", valid_579606
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

proc call*(call_579608: Call_StorageObjectAccessControlsInsert_579592;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_579608.validator(path, query, header, formData, body)
  let scheme = call_579608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579608.url(scheme.get, call_579608.host, call_579608.base,
                         call_579608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579608, url, valid)

proc call*(call_579609: Call_StorageObjectAccessControlsInsert_579592;
          bucket: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; provisionalUserProject: string = ""; fields: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579610 = newJObject()
  var query_579611 = newJObject()
  var body_579612 = newJObject()
  add(query_579611, "key", newJString(key))
  add(query_579611, "prettyPrint", newJBool(prettyPrint))
  add(query_579611, "oauth_token", newJString(oauthToken))
  add(query_579611, "generation", newJString(generation))
  add(query_579611, "userProject", newJString(userProject))
  add(query_579611, "alt", newJString(alt))
  add(query_579611, "userIp", newJString(userIp))
  add(query_579611, "quotaUser", newJString(quotaUser))
  add(path_579610, "bucket", newJString(bucket))
  if body != nil:
    body_579612 = body
  add(query_579611, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579610, "object", newJString(`object`))
  add(query_579611, "fields", newJString(fields))
  result = call_579609.call(path_579610, query_579611, nil, nil, body_579612)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_579592(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_579593,
    base: "/storage/v1", url: url_StorageObjectAccessControlsInsert_579594,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_579573 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsList_579575(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsList_579574(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves ACL entries on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579576 = path.getOrDefault("bucket")
  valid_579576 = validateParameter(valid_579576, JString, required = true,
                                 default = nil)
  if valid_579576 != nil:
    section.add "bucket", valid_579576
  var valid_579577 = path.getOrDefault("object")
  valid_579577 = validateParameter(valid_579577, JString, required = true,
                                 default = nil)
  if valid_579577 != nil:
    section.add "object", valid_579577
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579578 = query.getOrDefault("key")
  valid_579578 = validateParameter(valid_579578, JString, required = false,
                                 default = nil)
  if valid_579578 != nil:
    section.add "key", valid_579578
  var valid_579579 = query.getOrDefault("prettyPrint")
  valid_579579 = validateParameter(valid_579579, JBool, required = false,
                                 default = newJBool(true))
  if valid_579579 != nil:
    section.add "prettyPrint", valid_579579
  var valid_579580 = query.getOrDefault("oauth_token")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = nil)
  if valid_579580 != nil:
    section.add "oauth_token", valid_579580
  var valid_579581 = query.getOrDefault("generation")
  valid_579581 = validateParameter(valid_579581, JString, required = false,
                                 default = nil)
  if valid_579581 != nil:
    section.add "generation", valid_579581
  var valid_579582 = query.getOrDefault("userProject")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "userProject", valid_579582
  var valid_579583 = query.getOrDefault("alt")
  valid_579583 = validateParameter(valid_579583, JString, required = false,
                                 default = newJString("json"))
  if valid_579583 != nil:
    section.add "alt", valid_579583
  var valid_579584 = query.getOrDefault("userIp")
  valid_579584 = validateParameter(valid_579584, JString, required = false,
                                 default = nil)
  if valid_579584 != nil:
    section.add "userIp", valid_579584
  var valid_579585 = query.getOrDefault("quotaUser")
  valid_579585 = validateParameter(valid_579585, JString, required = false,
                                 default = nil)
  if valid_579585 != nil:
    section.add "quotaUser", valid_579585
  var valid_579586 = query.getOrDefault("provisionalUserProject")
  valid_579586 = validateParameter(valid_579586, JString, required = false,
                                 default = nil)
  if valid_579586 != nil:
    section.add "provisionalUserProject", valid_579586
  var valid_579587 = query.getOrDefault("fields")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = nil)
  if valid_579587 != nil:
    section.add "fields", valid_579587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579588: Call_StorageObjectAccessControlsList_579573;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_579588.validator(path, query, header, formData, body)
  let scheme = call_579588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579588.url(scheme.get, call_579588.host, call_579588.base,
                         call_579588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579588, url, valid)

proc call*(call_579589: Call_StorageObjectAccessControlsList_579573;
          bucket: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579590 = newJObject()
  var query_579591 = newJObject()
  add(query_579591, "key", newJString(key))
  add(query_579591, "prettyPrint", newJBool(prettyPrint))
  add(query_579591, "oauth_token", newJString(oauthToken))
  add(query_579591, "generation", newJString(generation))
  add(query_579591, "userProject", newJString(userProject))
  add(query_579591, "alt", newJString(alt))
  add(query_579591, "userIp", newJString(userIp))
  add(query_579591, "quotaUser", newJString(quotaUser))
  add(path_579590, "bucket", newJString(bucket))
  add(query_579591, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579590, "object", newJString(`object`))
  add(query_579591, "fields", newJString(fields))
  result = call_579589.call(path_579590, query_579591, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_579573(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_579574,
    base: "/storage/v1", url: url_StorageObjectAccessControlsList_579575,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_579633 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsUpdate_579635(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsUpdate_579634(path: JsonNode;
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579636 = path.getOrDefault("bucket")
  valid_579636 = validateParameter(valid_579636, JString, required = true,
                                 default = nil)
  if valid_579636 != nil:
    section.add "bucket", valid_579636
  var valid_579637 = path.getOrDefault("entity")
  valid_579637 = validateParameter(valid_579637, JString, required = true,
                                 default = nil)
  if valid_579637 != nil:
    section.add "entity", valid_579637
  var valid_579638 = path.getOrDefault("object")
  valid_579638 = validateParameter(valid_579638, JString, required = true,
                                 default = nil)
  if valid_579638 != nil:
    section.add "object", valid_579638
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579639 = query.getOrDefault("key")
  valid_579639 = validateParameter(valid_579639, JString, required = false,
                                 default = nil)
  if valid_579639 != nil:
    section.add "key", valid_579639
  var valid_579640 = query.getOrDefault("prettyPrint")
  valid_579640 = validateParameter(valid_579640, JBool, required = false,
                                 default = newJBool(true))
  if valid_579640 != nil:
    section.add "prettyPrint", valid_579640
  var valid_579641 = query.getOrDefault("oauth_token")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = nil)
  if valid_579641 != nil:
    section.add "oauth_token", valid_579641
  var valid_579642 = query.getOrDefault("generation")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "generation", valid_579642
  var valid_579643 = query.getOrDefault("userProject")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "userProject", valid_579643
  var valid_579644 = query.getOrDefault("alt")
  valid_579644 = validateParameter(valid_579644, JString, required = false,
                                 default = newJString("json"))
  if valid_579644 != nil:
    section.add "alt", valid_579644
  var valid_579645 = query.getOrDefault("userIp")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = nil)
  if valid_579645 != nil:
    section.add "userIp", valid_579645
  var valid_579646 = query.getOrDefault("quotaUser")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = nil)
  if valid_579646 != nil:
    section.add "quotaUser", valid_579646
  var valid_579647 = query.getOrDefault("provisionalUserProject")
  valid_579647 = validateParameter(valid_579647, JString, required = false,
                                 default = nil)
  if valid_579647 != nil:
    section.add "provisionalUserProject", valid_579647
  var valid_579648 = query.getOrDefault("fields")
  valid_579648 = validateParameter(valid_579648, JString, required = false,
                                 default = nil)
  if valid_579648 != nil:
    section.add "fields", valid_579648
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

proc call*(call_579650: Call_StorageObjectAccessControlsUpdate_579633;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_579650.validator(path, query, header, formData, body)
  let scheme = call_579650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579650.url(scheme.get, call_579650.host, call_579650.base,
                         call_579650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579650, url, valid)

proc call*(call_579651: Call_StorageObjectAccessControlsUpdate_579633;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579652 = newJObject()
  var query_579653 = newJObject()
  var body_579654 = newJObject()
  add(query_579653, "key", newJString(key))
  add(query_579653, "prettyPrint", newJBool(prettyPrint))
  add(query_579653, "oauth_token", newJString(oauthToken))
  add(query_579653, "generation", newJString(generation))
  add(query_579653, "userProject", newJString(userProject))
  add(query_579653, "alt", newJString(alt))
  add(query_579653, "userIp", newJString(userIp))
  add(query_579653, "quotaUser", newJString(quotaUser))
  add(path_579652, "bucket", newJString(bucket))
  if body != nil:
    body_579654 = body
  add(query_579653, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579652, "entity", newJString(entity))
  add(path_579652, "object", newJString(`object`))
  add(query_579653, "fields", newJString(fields))
  result = call_579651.call(path_579652, query_579653, nil, nil, body_579654)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_579633(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_579634,
    base: "/storage/v1", url: url_StorageObjectAccessControlsUpdate_579635,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_579613 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsGet_579615(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsGet_579614(path: JsonNode;
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579616 = path.getOrDefault("bucket")
  valid_579616 = validateParameter(valid_579616, JString, required = true,
                                 default = nil)
  if valid_579616 != nil:
    section.add "bucket", valid_579616
  var valid_579617 = path.getOrDefault("entity")
  valid_579617 = validateParameter(valid_579617, JString, required = true,
                                 default = nil)
  if valid_579617 != nil:
    section.add "entity", valid_579617
  var valid_579618 = path.getOrDefault("object")
  valid_579618 = validateParameter(valid_579618, JString, required = true,
                                 default = nil)
  if valid_579618 != nil:
    section.add "object", valid_579618
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579619 = query.getOrDefault("key")
  valid_579619 = validateParameter(valid_579619, JString, required = false,
                                 default = nil)
  if valid_579619 != nil:
    section.add "key", valid_579619
  var valid_579620 = query.getOrDefault("prettyPrint")
  valid_579620 = validateParameter(valid_579620, JBool, required = false,
                                 default = newJBool(true))
  if valid_579620 != nil:
    section.add "prettyPrint", valid_579620
  var valid_579621 = query.getOrDefault("oauth_token")
  valid_579621 = validateParameter(valid_579621, JString, required = false,
                                 default = nil)
  if valid_579621 != nil:
    section.add "oauth_token", valid_579621
  var valid_579622 = query.getOrDefault("generation")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "generation", valid_579622
  var valid_579623 = query.getOrDefault("userProject")
  valid_579623 = validateParameter(valid_579623, JString, required = false,
                                 default = nil)
  if valid_579623 != nil:
    section.add "userProject", valid_579623
  var valid_579624 = query.getOrDefault("alt")
  valid_579624 = validateParameter(valid_579624, JString, required = false,
                                 default = newJString("json"))
  if valid_579624 != nil:
    section.add "alt", valid_579624
  var valid_579625 = query.getOrDefault("userIp")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = nil)
  if valid_579625 != nil:
    section.add "userIp", valid_579625
  var valid_579626 = query.getOrDefault("quotaUser")
  valid_579626 = validateParameter(valid_579626, JString, required = false,
                                 default = nil)
  if valid_579626 != nil:
    section.add "quotaUser", valid_579626
  var valid_579627 = query.getOrDefault("provisionalUserProject")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = nil)
  if valid_579627 != nil:
    section.add "provisionalUserProject", valid_579627
  var valid_579628 = query.getOrDefault("fields")
  valid_579628 = validateParameter(valid_579628, JString, required = false,
                                 default = nil)
  if valid_579628 != nil:
    section.add "fields", valid_579628
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579629: Call_StorageObjectAccessControlsGet_579613; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_579629.validator(path, query, header, formData, body)
  let scheme = call_579629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579629.url(scheme.get, call_579629.host, call_579629.base,
                         call_579629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579629, url, valid)

proc call*(call_579630: Call_StorageObjectAccessControlsGet_579613; bucket: string;
          entity: string; `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579631 = newJObject()
  var query_579632 = newJObject()
  add(query_579632, "key", newJString(key))
  add(query_579632, "prettyPrint", newJBool(prettyPrint))
  add(query_579632, "oauth_token", newJString(oauthToken))
  add(query_579632, "generation", newJString(generation))
  add(query_579632, "userProject", newJString(userProject))
  add(query_579632, "alt", newJString(alt))
  add(query_579632, "userIp", newJString(userIp))
  add(query_579632, "quotaUser", newJString(quotaUser))
  add(path_579631, "bucket", newJString(bucket))
  add(query_579632, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579631, "entity", newJString(entity))
  add(path_579631, "object", newJString(`object`))
  add(query_579632, "fields", newJString(fields))
  result = call_579630.call(path_579631, query_579632, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_579613(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_579614,
    base: "/storage/v1", url: url_StorageObjectAccessControlsGet_579615,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_579675 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsPatch_579677(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsPatch_579676(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches an ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579678 = path.getOrDefault("bucket")
  valid_579678 = validateParameter(valid_579678, JString, required = true,
                                 default = nil)
  if valid_579678 != nil:
    section.add "bucket", valid_579678
  var valid_579679 = path.getOrDefault("entity")
  valid_579679 = validateParameter(valid_579679, JString, required = true,
                                 default = nil)
  if valid_579679 != nil:
    section.add "entity", valid_579679
  var valid_579680 = path.getOrDefault("object")
  valid_579680 = validateParameter(valid_579680, JString, required = true,
                                 default = nil)
  if valid_579680 != nil:
    section.add "object", valid_579680
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579681 = query.getOrDefault("key")
  valid_579681 = validateParameter(valid_579681, JString, required = false,
                                 default = nil)
  if valid_579681 != nil:
    section.add "key", valid_579681
  var valid_579682 = query.getOrDefault("prettyPrint")
  valid_579682 = validateParameter(valid_579682, JBool, required = false,
                                 default = newJBool(true))
  if valid_579682 != nil:
    section.add "prettyPrint", valid_579682
  var valid_579683 = query.getOrDefault("oauth_token")
  valid_579683 = validateParameter(valid_579683, JString, required = false,
                                 default = nil)
  if valid_579683 != nil:
    section.add "oauth_token", valid_579683
  var valid_579684 = query.getOrDefault("generation")
  valid_579684 = validateParameter(valid_579684, JString, required = false,
                                 default = nil)
  if valid_579684 != nil:
    section.add "generation", valid_579684
  var valid_579685 = query.getOrDefault("userProject")
  valid_579685 = validateParameter(valid_579685, JString, required = false,
                                 default = nil)
  if valid_579685 != nil:
    section.add "userProject", valid_579685
  var valid_579686 = query.getOrDefault("alt")
  valid_579686 = validateParameter(valid_579686, JString, required = false,
                                 default = newJString("json"))
  if valid_579686 != nil:
    section.add "alt", valid_579686
  var valid_579687 = query.getOrDefault("userIp")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = nil)
  if valid_579687 != nil:
    section.add "userIp", valid_579687
  var valid_579688 = query.getOrDefault("quotaUser")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = nil)
  if valid_579688 != nil:
    section.add "quotaUser", valid_579688
  var valid_579689 = query.getOrDefault("provisionalUserProject")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = nil)
  if valid_579689 != nil:
    section.add "provisionalUserProject", valid_579689
  var valid_579690 = query.getOrDefault("fields")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "fields", valid_579690
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

proc call*(call_579692: Call_StorageObjectAccessControlsPatch_579675;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches an ACL entry on the specified object.
  ## 
  let valid = call_579692.validator(path, query, header, formData, body)
  let scheme = call_579692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579692.url(scheme.get, call_579692.host, call_579692.base,
                         call_579692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579692, url, valid)

proc call*(call_579693: Call_StorageObjectAccessControlsPatch_579675;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectAccessControlsPatch
  ## Patches an ACL entry on the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579694 = newJObject()
  var query_579695 = newJObject()
  var body_579696 = newJObject()
  add(query_579695, "key", newJString(key))
  add(query_579695, "prettyPrint", newJBool(prettyPrint))
  add(query_579695, "oauth_token", newJString(oauthToken))
  add(query_579695, "generation", newJString(generation))
  add(query_579695, "userProject", newJString(userProject))
  add(query_579695, "alt", newJString(alt))
  add(query_579695, "userIp", newJString(userIp))
  add(query_579695, "quotaUser", newJString(quotaUser))
  add(path_579694, "bucket", newJString(bucket))
  if body != nil:
    body_579696 = body
  add(query_579695, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579694, "entity", newJString(entity))
  add(path_579694, "object", newJString(`object`))
  add(query_579695, "fields", newJString(fields))
  result = call_579693.call(path_579694, query_579695, nil, nil, body_579696)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_579675(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_579676,
    base: "/storage/v1", url: url_StorageObjectAccessControlsPatch_579677,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_579655 = ref object of OpenApiRestCall_578355
proc url_StorageObjectAccessControlsDelete_579657(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsDelete_579656(path: JsonNode;
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579658 = path.getOrDefault("bucket")
  valid_579658 = validateParameter(valid_579658, JString, required = true,
                                 default = nil)
  if valid_579658 != nil:
    section.add "bucket", valid_579658
  var valid_579659 = path.getOrDefault("entity")
  valid_579659 = validateParameter(valid_579659, JString, required = true,
                                 default = nil)
  if valid_579659 != nil:
    section.add "entity", valid_579659
  var valid_579660 = path.getOrDefault("object")
  valid_579660 = validateParameter(valid_579660, JString, required = true,
                                 default = nil)
  if valid_579660 != nil:
    section.add "object", valid_579660
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579661 = query.getOrDefault("key")
  valid_579661 = validateParameter(valid_579661, JString, required = false,
                                 default = nil)
  if valid_579661 != nil:
    section.add "key", valid_579661
  var valid_579662 = query.getOrDefault("prettyPrint")
  valid_579662 = validateParameter(valid_579662, JBool, required = false,
                                 default = newJBool(true))
  if valid_579662 != nil:
    section.add "prettyPrint", valid_579662
  var valid_579663 = query.getOrDefault("oauth_token")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "oauth_token", valid_579663
  var valid_579664 = query.getOrDefault("generation")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = nil)
  if valid_579664 != nil:
    section.add "generation", valid_579664
  var valid_579665 = query.getOrDefault("userProject")
  valid_579665 = validateParameter(valid_579665, JString, required = false,
                                 default = nil)
  if valid_579665 != nil:
    section.add "userProject", valid_579665
  var valid_579666 = query.getOrDefault("alt")
  valid_579666 = validateParameter(valid_579666, JString, required = false,
                                 default = newJString("json"))
  if valid_579666 != nil:
    section.add "alt", valid_579666
  var valid_579667 = query.getOrDefault("userIp")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = nil)
  if valid_579667 != nil:
    section.add "userIp", valid_579667
  var valid_579668 = query.getOrDefault("quotaUser")
  valid_579668 = validateParameter(valid_579668, JString, required = false,
                                 default = nil)
  if valid_579668 != nil:
    section.add "quotaUser", valid_579668
  var valid_579669 = query.getOrDefault("provisionalUserProject")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = nil)
  if valid_579669 != nil:
    section.add "provisionalUserProject", valid_579669
  var valid_579670 = query.getOrDefault("fields")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = nil)
  if valid_579670 != nil:
    section.add "fields", valid_579670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579671: Call_StorageObjectAccessControlsDelete_579655;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_579671.validator(path, query, header, formData, body)
  let scheme = call_579671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579671.url(scheme.get, call_579671.host, call_579671.base,
                         call_579671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579671, url, valid)

proc call*(call_579672: Call_StorageObjectAccessControlsDelete_579655;
          bucket: string; entity: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; provisionalUserProject: string = "";
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579673 = newJObject()
  var query_579674 = newJObject()
  add(query_579674, "key", newJString(key))
  add(query_579674, "prettyPrint", newJBool(prettyPrint))
  add(query_579674, "oauth_token", newJString(oauthToken))
  add(query_579674, "generation", newJString(generation))
  add(query_579674, "userProject", newJString(userProject))
  add(query_579674, "alt", newJString(alt))
  add(query_579674, "userIp", newJString(userIp))
  add(query_579674, "quotaUser", newJString(quotaUser))
  add(path_579673, "bucket", newJString(bucket))
  add(query_579674, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579673, "entity", newJString(entity))
  add(path_579673, "object", newJString(`object`))
  add(query_579674, "fields", newJString(fields))
  result = call_579672.call(path_579673, query_579674, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_579655(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_579656,
    base: "/storage/v1", url: url_StorageObjectAccessControlsDelete_579657,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsSetIamPolicy_579716 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsSetIamPolicy_579718(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsSetIamPolicy_579717(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an IAM policy for the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579719 = path.getOrDefault("bucket")
  valid_579719 = validateParameter(valid_579719, JString, required = true,
                                 default = nil)
  if valid_579719 != nil:
    section.add "bucket", valid_579719
  var valid_579720 = path.getOrDefault("object")
  valid_579720 = validateParameter(valid_579720, JString, required = true,
                                 default = nil)
  if valid_579720 != nil:
    section.add "object", valid_579720
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579721 = query.getOrDefault("key")
  valid_579721 = validateParameter(valid_579721, JString, required = false,
                                 default = nil)
  if valid_579721 != nil:
    section.add "key", valid_579721
  var valid_579722 = query.getOrDefault("prettyPrint")
  valid_579722 = validateParameter(valid_579722, JBool, required = false,
                                 default = newJBool(true))
  if valid_579722 != nil:
    section.add "prettyPrint", valid_579722
  var valid_579723 = query.getOrDefault("oauth_token")
  valid_579723 = validateParameter(valid_579723, JString, required = false,
                                 default = nil)
  if valid_579723 != nil:
    section.add "oauth_token", valid_579723
  var valid_579724 = query.getOrDefault("generation")
  valid_579724 = validateParameter(valid_579724, JString, required = false,
                                 default = nil)
  if valid_579724 != nil:
    section.add "generation", valid_579724
  var valid_579725 = query.getOrDefault("userProject")
  valid_579725 = validateParameter(valid_579725, JString, required = false,
                                 default = nil)
  if valid_579725 != nil:
    section.add "userProject", valid_579725
  var valid_579726 = query.getOrDefault("alt")
  valid_579726 = validateParameter(valid_579726, JString, required = false,
                                 default = newJString("json"))
  if valid_579726 != nil:
    section.add "alt", valid_579726
  var valid_579727 = query.getOrDefault("userIp")
  valid_579727 = validateParameter(valid_579727, JString, required = false,
                                 default = nil)
  if valid_579727 != nil:
    section.add "userIp", valid_579727
  var valid_579728 = query.getOrDefault("quotaUser")
  valid_579728 = validateParameter(valid_579728, JString, required = false,
                                 default = nil)
  if valid_579728 != nil:
    section.add "quotaUser", valid_579728
  var valid_579729 = query.getOrDefault("provisionalUserProject")
  valid_579729 = validateParameter(valid_579729, JString, required = false,
                                 default = nil)
  if valid_579729 != nil:
    section.add "provisionalUserProject", valid_579729
  var valid_579730 = query.getOrDefault("fields")
  valid_579730 = validateParameter(valid_579730, JString, required = false,
                                 default = nil)
  if valid_579730 != nil:
    section.add "fields", valid_579730
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

proc call*(call_579732: Call_StorageObjectsSetIamPolicy_579716; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an IAM policy for the specified object.
  ## 
  let valid = call_579732.validator(path, query, header, formData, body)
  let scheme = call_579732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579732.url(scheme.get, call_579732.host, call_579732.base,
                         call_579732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579732, url, valid)

proc call*(call_579733: Call_StorageObjectsSetIamPolicy_579716; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectsSetIamPolicy
  ## Updates an IAM policy for the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579734 = newJObject()
  var query_579735 = newJObject()
  var body_579736 = newJObject()
  add(query_579735, "key", newJString(key))
  add(query_579735, "prettyPrint", newJBool(prettyPrint))
  add(query_579735, "oauth_token", newJString(oauthToken))
  add(query_579735, "generation", newJString(generation))
  add(query_579735, "userProject", newJString(userProject))
  add(query_579735, "alt", newJString(alt))
  add(query_579735, "userIp", newJString(userIp))
  add(query_579735, "quotaUser", newJString(quotaUser))
  add(path_579734, "bucket", newJString(bucket))
  if body != nil:
    body_579736 = body
  add(query_579735, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579734, "object", newJString(`object`))
  add(query_579735, "fields", newJString(fields))
  result = call_579733.call(path_579734, query_579735, nil, nil, body_579736)

var storageObjectsSetIamPolicy* = Call_StorageObjectsSetIamPolicy_579716(
    name: "storageObjectsSetIamPolicy", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/iam",
    validator: validate_StorageObjectsSetIamPolicy_579717, base: "/storage/v1",
    url: url_StorageObjectsSetIamPolicy_579718, schemes: {Scheme.Https})
type
  Call_StorageObjectsGetIamPolicy_579697 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsGetIamPolicy_579699(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsGetIamPolicy_579698(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an IAM policy for the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579700 = path.getOrDefault("bucket")
  valid_579700 = validateParameter(valid_579700, JString, required = true,
                                 default = nil)
  if valid_579700 != nil:
    section.add "bucket", valid_579700
  var valid_579701 = path.getOrDefault("object")
  valid_579701 = validateParameter(valid_579701, JString, required = true,
                                 default = nil)
  if valid_579701 != nil:
    section.add "object", valid_579701
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579702 = query.getOrDefault("key")
  valid_579702 = validateParameter(valid_579702, JString, required = false,
                                 default = nil)
  if valid_579702 != nil:
    section.add "key", valid_579702
  var valid_579703 = query.getOrDefault("prettyPrint")
  valid_579703 = validateParameter(valid_579703, JBool, required = false,
                                 default = newJBool(true))
  if valid_579703 != nil:
    section.add "prettyPrint", valid_579703
  var valid_579704 = query.getOrDefault("oauth_token")
  valid_579704 = validateParameter(valid_579704, JString, required = false,
                                 default = nil)
  if valid_579704 != nil:
    section.add "oauth_token", valid_579704
  var valid_579705 = query.getOrDefault("generation")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = nil)
  if valid_579705 != nil:
    section.add "generation", valid_579705
  var valid_579706 = query.getOrDefault("userProject")
  valid_579706 = validateParameter(valid_579706, JString, required = false,
                                 default = nil)
  if valid_579706 != nil:
    section.add "userProject", valid_579706
  var valid_579707 = query.getOrDefault("alt")
  valid_579707 = validateParameter(valid_579707, JString, required = false,
                                 default = newJString("json"))
  if valid_579707 != nil:
    section.add "alt", valid_579707
  var valid_579708 = query.getOrDefault("userIp")
  valid_579708 = validateParameter(valid_579708, JString, required = false,
                                 default = nil)
  if valid_579708 != nil:
    section.add "userIp", valid_579708
  var valid_579709 = query.getOrDefault("quotaUser")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = nil)
  if valid_579709 != nil:
    section.add "quotaUser", valid_579709
  var valid_579710 = query.getOrDefault("provisionalUserProject")
  valid_579710 = validateParameter(valid_579710, JString, required = false,
                                 default = nil)
  if valid_579710 != nil:
    section.add "provisionalUserProject", valid_579710
  var valid_579711 = query.getOrDefault("fields")
  valid_579711 = validateParameter(valid_579711, JString, required = false,
                                 default = nil)
  if valid_579711 != nil:
    section.add "fields", valid_579711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579712: Call_StorageObjectsGetIamPolicy_579697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an IAM policy for the specified object.
  ## 
  let valid = call_579712.validator(path, query, header, formData, body)
  let scheme = call_579712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579712.url(scheme.get, call_579712.host, call_579712.base,
                         call_579712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579712, url, valid)

proc call*(call_579713: Call_StorageObjectsGetIamPolicy_579697; bucket: string;
          `object`: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; generation: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectsGetIamPolicy
  ## Returns an IAM policy for the specified object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579714 = newJObject()
  var query_579715 = newJObject()
  add(query_579715, "key", newJString(key))
  add(query_579715, "prettyPrint", newJBool(prettyPrint))
  add(query_579715, "oauth_token", newJString(oauthToken))
  add(query_579715, "generation", newJString(generation))
  add(query_579715, "userProject", newJString(userProject))
  add(query_579715, "alt", newJString(alt))
  add(query_579715, "userIp", newJString(userIp))
  add(query_579715, "quotaUser", newJString(quotaUser))
  add(path_579714, "bucket", newJString(bucket))
  add(query_579715, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579714, "object", newJString(`object`))
  add(query_579715, "fields", newJString(fields))
  result = call_579713.call(path_579714, query_579715, nil, nil, nil)

var storageObjectsGetIamPolicy* = Call_StorageObjectsGetIamPolicy_579697(
    name: "storageObjectsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/iam",
    validator: validate_StorageObjectsGetIamPolicy_579698, base: "/storage/v1",
    url: url_StorageObjectsGetIamPolicy_579699, schemes: {Scheme.Https})
type
  Call_StorageObjectsTestIamPermissions_579737 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsTestIamPermissions_579739(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iam/testPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsTestIamPermissions_579738(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_579740 = path.getOrDefault("bucket")
  valid_579740 = validateParameter(valid_579740, JString, required = true,
                                 default = nil)
  if valid_579740 != nil:
    section.add "bucket", valid_579740
  var valid_579741 = path.getOrDefault("object")
  valid_579741 = validateParameter(valid_579741, JString, required = true,
                                 default = nil)
  if valid_579741 != nil:
    section.add "object", valid_579741
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579742 = query.getOrDefault("key")
  valid_579742 = validateParameter(valid_579742, JString, required = false,
                                 default = nil)
  if valid_579742 != nil:
    section.add "key", valid_579742
  var valid_579743 = query.getOrDefault("prettyPrint")
  valid_579743 = validateParameter(valid_579743, JBool, required = false,
                                 default = newJBool(true))
  if valid_579743 != nil:
    section.add "prettyPrint", valid_579743
  var valid_579744 = query.getOrDefault("oauth_token")
  valid_579744 = validateParameter(valid_579744, JString, required = false,
                                 default = nil)
  if valid_579744 != nil:
    section.add "oauth_token", valid_579744
  var valid_579745 = query.getOrDefault("generation")
  valid_579745 = validateParameter(valid_579745, JString, required = false,
                                 default = nil)
  if valid_579745 != nil:
    section.add "generation", valid_579745
  var valid_579746 = query.getOrDefault("userProject")
  valid_579746 = validateParameter(valid_579746, JString, required = false,
                                 default = nil)
  if valid_579746 != nil:
    section.add "userProject", valid_579746
  assert query != nil,
        "query argument is necessary due to required `permissions` field"
  var valid_579747 = query.getOrDefault("permissions")
  valid_579747 = validateParameter(valid_579747, JArray, required = true, default = nil)
  if valid_579747 != nil:
    section.add "permissions", valid_579747
  var valid_579748 = query.getOrDefault("alt")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = newJString("json"))
  if valid_579748 != nil:
    section.add "alt", valid_579748
  var valid_579749 = query.getOrDefault("userIp")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "userIp", valid_579749
  var valid_579750 = query.getOrDefault("quotaUser")
  valid_579750 = validateParameter(valid_579750, JString, required = false,
                                 default = nil)
  if valid_579750 != nil:
    section.add "quotaUser", valid_579750
  var valid_579751 = query.getOrDefault("provisionalUserProject")
  valid_579751 = validateParameter(valid_579751, JString, required = false,
                                 default = nil)
  if valid_579751 != nil:
    section.add "provisionalUserProject", valid_579751
  var valid_579752 = query.getOrDefault("fields")
  valid_579752 = validateParameter(valid_579752, JString, required = false,
                                 default = nil)
  if valid_579752 != nil:
    section.add "fields", valid_579752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579753: Call_StorageObjectsTestIamPermissions_579737;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ## 
  let valid = call_579753.validator(path, query, header, formData, body)
  let scheme = call_579753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579753.url(scheme.get, call_579753.host, call_579753.base,
                         call_579753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579753, url, valid)

proc call*(call_579754: Call_StorageObjectsTestIamPermissions_579737;
          permissions: JsonNode; bucket: string; `object`: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; generation: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; provisionalUserProject: string = "";
          fields: string = ""): Recallable =
  ## storageObjectsTestIamPermissions
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579755 = newJObject()
  var query_579756 = newJObject()
  add(query_579756, "key", newJString(key))
  add(query_579756, "prettyPrint", newJBool(prettyPrint))
  add(query_579756, "oauth_token", newJString(oauthToken))
  add(query_579756, "generation", newJString(generation))
  add(query_579756, "userProject", newJString(userProject))
  if permissions != nil:
    query_579756.add "permissions", permissions
  add(query_579756, "alt", newJString(alt))
  add(query_579756, "userIp", newJString(userIp))
  add(query_579756, "quotaUser", newJString(quotaUser))
  add(path_579755, "bucket", newJString(bucket))
  add(query_579756, "provisionalUserProject", newJString(provisionalUserProject))
  add(path_579755, "object", newJString(`object`))
  add(query_579756, "fields", newJString(fields))
  result = call_579754.call(path_579755, query_579756, nil, nil, nil)

var storageObjectsTestIamPermissions* = Call_StorageObjectsTestIamPermissions_579737(
    name: "storageObjectsTestIamPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/b/{bucket}/o/{object}/iam/testPermissions",
    validator: validate_StorageObjectsTestIamPermissions_579738,
    base: "/storage/v1", url: url_StorageObjectsTestIamPermissions_579739,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsCompose_579757 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsCompose_579759(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsCompose_579758(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationObject` field"
  var valid_579760 = path.getOrDefault("destinationObject")
  valid_579760 = validateParameter(valid_579760, JString, required = true,
                                 default = nil)
  if valid_579760 != nil:
    section.add "destinationObject", valid_579760
  var valid_579761 = path.getOrDefault("destinationBucket")
  valid_579761 = validateParameter(valid_579761, JString, required = true,
                                 default = nil)
  if valid_579761 != nil:
    section.add "destinationBucket", valid_579761
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   kmsKeyName: JString
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579762 = query.getOrDefault("key")
  valid_579762 = validateParameter(valid_579762, JString, required = false,
                                 default = nil)
  if valid_579762 != nil:
    section.add "key", valid_579762
  var valid_579763 = query.getOrDefault("prettyPrint")
  valid_579763 = validateParameter(valid_579763, JBool, required = false,
                                 default = newJBool(true))
  if valid_579763 != nil:
    section.add "prettyPrint", valid_579763
  var valid_579764 = query.getOrDefault("oauth_token")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "oauth_token", valid_579764
  var valid_579765 = query.getOrDefault("kmsKeyName")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = nil)
  if valid_579765 != nil:
    section.add "kmsKeyName", valid_579765
  var valid_579766 = query.getOrDefault("destinationPredefinedAcl")
  valid_579766 = validateParameter(valid_579766, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579766 != nil:
    section.add "destinationPredefinedAcl", valid_579766
  var valid_579767 = query.getOrDefault("userProject")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "userProject", valid_579767
  var valid_579768 = query.getOrDefault("ifGenerationMatch")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = nil)
  if valid_579768 != nil:
    section.add "ifGenerationMatch", valid_579768
  var valid_579769 = query.getOrDefault("alt")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = newJString("json"))
  if valid_579769 != nil:
    section.add "alt", valid_579769
  var valid_579770 = query.getOrDefault("userIp")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = nil)
  if valid_579770 != nil:
    section.add "userIp", valid_579770
  var valid_579771 = query.getOrDefault("quotaUser")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "quotaUser", valid_579771
  var valid_579772 = query.getOrDefault("ifMetagenerationMatch")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "ifMetagenerationMatch", valid_579772
  var valid_579773 = query.getOrDefault("provisionalUserProject")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "provisionalUserProject", valid_579773
  var valid_579774 = query.getOrDefault("fields")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "fields", valid_579774
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

proc call*(call_579776: Call_StorageObjectsCompose_579757; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  let valid = call_579776.validator(path, query, header, formData, body)
  let scheme = call_579776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579776.url(scheme.get, call_579776.host, call_579776.base,
                         call_579776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579776, url, valid)

proc call*(call_579777: Call_StorageObjectsCompose_579757;
          destinationObject: string; destinationBucket: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; kmsKeyName: string = "";
          destinationPredefinedAcl: string = "authenticatedRead";
          userProject: string = ""; ifGenerationMatch: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageObjectsCompose
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   kmsKeyName: string
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579778 = newJObject()
  var query_579779 = newJObject()
  var body_579780 = newJObject()
  add(query_579779, "key", newJString(key))
  add(query_579779, "prettyPrint", newJBool(prettyPrint))
  add(query_579779, "oauth_token", newJString(oauthToken))
  add(query_579779, "kmsKeyName", newJString(kmsKeyName))
  add(path_579778, "destinationObject", newJString(destinationObject))
  add(query_579779, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_579779, "userProject", newJString(userProject))
  add(path_579778, "destinationBucket", newJString(destinationBucket))
  add(query_579779, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579779, "alt", newJString(alt))
  add(query_579779, "userIp", newJString(userIp))
  add(query_579779, "quotaUser", newJString(quotaUser))
  add(query_579779, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_579780 = body
  add(query_579779, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579779, "fields", newJString(fields))
  result = call_579777.call(path_579778, query_579779, nil, nil, body_579780)

var storageObjectsCompose* = Call_StorageObjectsCompose_579757(
    name: "storageObjectsCompose", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/b/{destinationBucket}/o/{destinationObject}/compose",
    validator: validate_StorageObjectsCompose_579758, base: "/storage/v1",
    url: url_StorageObjectsCompose_579759, schemes: {Scheme.Https})
type
  Call_StorageObjectsCopy_579781 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsCopy_579783(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsCopy_579782(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   sourceObject: JString (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   sourceBucket: JString (required)
  ##               : Name of the bucket in which to find the source object.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationObject` field"
  var valid_579784 = path.getOrDefault("destinationObject")
  valid_579784 = validateParameter(valid_579784, JString, required = true,
                                 default = nil)
  if valid_579784 != nil:
    section.add "destinationObject", valid_579784
  var valid_579785 = path.getOrDefault("destinationBucket")
  valid_579785 = validateParameter(valid_579785, JString, required = true,
                                 default = nil)
  if valid_579785 != nil:
    section.add "destinationBucket", valid_579785
  var valid_579786 = path.getOrDefault("sourceObject")
  valid_579786 = validateParameter(valid_579786, JString, required = true,
                                 default = nil)
  if valid_579786 != nil:
    section.add "sourceObject", valid_579786
  var valid_579787 = path.getOrDefault("sourceBucket")
  valid_579787 = validateParameter(valid_579787, JString, required = true,
                                 default = nil)
  if valid_579787 != nil:
    section.add "sourceBucket", valid_579787
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: JString
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifSourceMetagenerationNotMatch: JString
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: JString
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   sourceGeneration: JString
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: JString
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579788 = query.getOrDefault("key")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "key", valid_579788
  var valid_579789 = query.getOrDefault("ifSourceGenerationMatch")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = nil)
  if valid_579789 != nil:
    section.add "ifSourceGenerationMatch", valid_579789
  var valid_579790 = query.getOrDefault("prettyPrint")
  valid_579790 = validateParameter(valid_579790, JBool, required = false,
                                 default = newJBool(true))
  if valid_579790 != nil:
    section.add "prettyPrint", valid_579790
  var valid_579791 = query.getOrDefault("oauth_token")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "oauth_token", valid_579791
  var valid_579792 = query.getOrDefault("destinationPredefinedAcl")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579792 != nil:
    section.add "destinationPredefinedAcl", valid_579792
  var valid_579793 = query.getOrDefault("userProject")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "userProject", valid_579793
  var valid_579794 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_579794
  var valid_579795 = query.getOrDefault("ifGenerationMatch")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "ifGenerationMatch", valid_579795
  var valid_579796 = query.getOrDefault("alt")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = newJString("json"))
  if valid_579796 != nil:
    section.add "alt", valid_579796
  var valid_579797 = query.getOrDefault("userIp")
  valid_579797 = validateParameter(valid_579797, JString, required = false,
                                 default = nil)
  if valid_579797 != nil:
    section.add "userIp", valid_579797
  var valid_579798 = query.getOrDefault("ifGenerationNotMatch")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "ifGenerationNotMatch", valid_579798
  var valid_579799 = query.getOrDefault("quotaUser")
  valid_579799 = validateParameter(valid_579799, JString, required = false,
                                 default = nil)
  if valid_579799 != nil:
    section.add "quotaUser", valid_579799
  var valid_579800 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_579800 = validateParameter(valid_579800, JString, required = false,
                                 default = nil)
  if valid_579800 != nil:
    section.add "ifSourceGenerationNotMatch", valid_579800
  var valid_579801 = query.getOrDefault("ifMetagenerationMatch")
  valid_579801 = validateParameter(valid_579801, JString, required = false,
                                 default = nil)
  if valid_579801 != nil:
    section.add "ifMetagenerationMatch", valid_579801
  var valid_579802 = query.getOrDefault("sourceGeneration")
  valid_579802 = validateParameter(valid_579802, JString, required = false,
                                 default = nil)
  if valid_579802 != nil:
    section.add "sourceGeneration", valid_579802
  var valid_579803 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = nil)
  if valid_579803 != nil:
    section.add "ifSourceMetagenerationMatch", valid_579803
  var valid_579804 = query.getOrDefault("provisionalUserProject")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "provisionalUserProject", valid_579804
  var valid_579805 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "ifMetagenerationNotMatch", valid_579805
  var valid_579806 = query.getOrDefault("projection")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = newJString("full"))
  if valid_579806 != nil:
    section.add "projection", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
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

proc call*(call_579809: Call_StorageObjectsCopy_579781; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ## 
  let valid = call_579809.validator(path, query, header, formData, body)
  let scheme = call_579809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579809.url(scheme.get, call_579809.host, call_579809.base,
                         call_579809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579809, url, valid)

proc call*(call_579810: Call_StorageObjectsCopy_579781; destinationObject: string;
          destinationBucket: string; sourceObject: string; sourceBucket: string;
          key: string = ""; ifSourceGenerationMatch: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          destinationPredefinedAcl: string = "authenticatedRead";
          userProject: string = ""; ifSourceMetagenerationNotMatch: string = "";
          ifGenerationMatch: string = ""; alt: string = "json"; userIp: string = "";
          ifGenerationNotMatch: string = ""; quotaUser: string = "";
          ifSourceGenerationNotMatch: string = "";
          ifMetagenerationMatch: string = ""; sourceGeneration: string = "";
          ifSourceMetagenerationMatch: string = ""; body: JsonNode = nil;
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""): Recallable =
  ## storageObjectsCopy
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: string
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifSourceMetagenerationNotMatch: string
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: string
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   sourceObject: string (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   sourceGeneration: string
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: string
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   sourceBucket: string (required)
  ##               : Name of the bucket in which to find the source object.
  ##   body: JObject
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579811 = newJObject()
  var query_579812 = newJObject()
  var body_579813 = newJObject()
  add(query_579812, "key", newJString(key))
  add(query_579812, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_579812, "prettyPrint", newJBool(prettyPrint))
  add(query_579812, "oauth_token", newJString(oauthToken))
  add(path_579811, "destinationObject", newJString(destinationObject))
  add(query_579812, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_579812, "userProject", newJString(userProject))
  add(query_579812, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(path_579811, "destinationBucket", newJString(destinationBucket))
  add(query_579812, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579812, "alt", newJString(alt))
  add(query_579812, "userIp", newJString(userIp))
  add(query_579812, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579812, "quotaUser", newJString(quotaUser))
  add(query_579812, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  add(path_579811, "sourceObject", newJString(sourceObject))
  add(query_579812, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_579812, "sourceGeneration", newJString(sourceGeneration))
  add(query_579812, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(path_579811, "sourceBucket", newJString(sourceBucket))
  if body != nil:
    body_579813 = body
  add(query_579812, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579812, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579812, "projection", newJString(projection))
  add(query_579812, "fields", newJString(fields))
  result = call_579810.call(path_579811, query_579812, nil, nil, body_579813)

var storageObjectsCopy* = Call_StorageObjectsCopy_579781(
    name: "storageObjectsCopy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/copyTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsCopy_579782, base: "/storage/v1",
    url: url_StorageObjectsCopy_579783, schemes: {Scheme.Https})
type
  Call_StorageObjectsRewrite_579814 = ref object of OpenApiRestCall_578355
proc url_StorageObjectsRewrite_579816(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/rewriteTo/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsRewrite_579815(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   sourceObject: JString (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   sourceBucket: JString (required)
  ##               : Name of the bucket in which to find the source object.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationObject` field"
  var valid_579817 = path.getOrDefault("destinationObject")
  valid_579817 = validateParameter(valid_579817, JString, required = true,
                                 default = nil)
  if valid_579817 != nil:
    section.add "destinationObject", valid_579817
  var valid_579818 = path.getOrDefault("destinationBucket")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "destinationBucket", valid_579818
  var valid_579819 = path.getOrDefault("sourceObject")
  valid_579819 = validateParameter(valid_579819, JString, required = true,
                                 default = nil)
  if valid_579819 != nil:
    section.add "sourceObject", valid_579819
  var valid_579820 = path.getOrDefault("sourceBucket")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "sourceBucket", valid_579820
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: JString
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifSourceMetagenerationNotMatch: JString
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: JString
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   rewriteToken: JString
  ##               : Include this field (from the previous rewrite response) on each rewrite request after the first one, until the rewrite response 'done' flag is true. Calls that provide a rewriteToken can omit all other request fields, but if included those fields must match the values provided in the first rewrite request.
  ##   sourceGeneration: JString
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: JString
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   maxBytesRewrittenPerCall: JString
  ##                           : The maximum number of bytes that will be rewritten per rewrite request. Most callers shouldn't need to specify this parameter - it is primarily in place to support testing. If specified the value must be an integral multiple of 1 MiB (1048576). Also, this only applies to requests where the source and destination span locations and/or storage classes. Finally, this value must not change across rewrite calls else you'll get an error that the rewriteToken is invalid.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   destinationKmsKeyName: JString
  ##                        : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  section = newJObject()
  var valid_579821 = query.getOrDefault("key")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "key", valid_579821
  var valid_579822 = query.getOrDefault("ifSourceGenerationMatch")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "ifSourceGenerationMatch", valid_579822
  var valid_579823 = query.getOrDefault("prettyPrint")
  valid_579823 = validateParameter(valid_579823, JBool, required = false,
                                 default = newJBool(true))
  if valid_579823 != nil:
    section.add "prettyPrint", valid_579823
  var valid_579824 = query.getOrDefault("oauth_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "oauth_token", valid_579824
  var valid_579825 = query.getOrDefault("destinationPredefinedAcl")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_579825 != nil:
    section.add "destinationPredefinedAcl", valid_579825
  var valid_579826 = query.getOrDefault("userProject")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "userProject", valid_579826
  var valid_579827 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_579827
  var valid_579828 = query.getOrDefault("ifGenerationMatch")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "ifGenerationMatch", valid_579828
  var valid_579829 = query.getOrDefault("alt")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = newJString("json"))
  if valid_579829 != nil:
    section.add "alt", valid_579829
  var valid_579830 = query.getOrDefault("userIp")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "userIp", valid_579830
  var valid_579831 = query.getOrDefault("ifGenerationNotMatch")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "ifGenerationNotMatch", valid_579831
  var valid_579832 = query.getOrDefault("quotaUser")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "quotaUser", valid_579832
  var valid_579833 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = nil)
  if valid_579833 != nil:
    section.add "ifSourceGenerationNotMatch", valid_579833
  var valid_579834 = query.getOrDefault("ifMetagenerationMatch")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "ifMetagenerationMatch", valid_579834
  var valid_579835 = query.getOrDefault("rewriteToken")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "rewriteToken", valid_579835
  var valid_579836 = query.getOrDefault("sourceGeneration")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "sourceGeneration", valid_579836
  var valid_579837 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "ifSourceMetagenerationMatch", valid_579837
  var valid_579838 = query.getOrDefault("maxBytesRewrittenPerCall")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "maxBytesRewrittenPerCall", valid_579838
  var valid_579839 = query.getOrDefault("provisionalUserProject")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "provisionalUserProject", valid_579839
  var valid_579840 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "ifMetagenerationNotMatch", valid_579840
  var valid_579841 = query.getOrDefault("projection")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = newJString("full"))
  if valid_579841 != nil:
    section.add "projection", valid_579841
  var valid_579842 = query.getOrDefault("fields")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "fields", valid_579842
  var valid_579843 = query.getOrDefault("destinationKmsKeyName")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "destinationKmsKeyName", valid_579843
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

proc call*(call_579845: Call_StorageObjectsRewrite_579814; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ## 
  let valid = call_579845.validator(path, query, header, formData, body)
  let scheme = call_579845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579845.url(scheme.get, call_579845.host, call_579845.base,
                         call_579845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579845, url, valid)

proc call*(call_579846: Call_StorageObjectsRewrite_579814;
          destinationObject: string; destinationBucket: string;
          sourceObject: string; sourceBucket: string; key: string = "";
          ifSourceGenerationMatch: string = ""; prettyPrint: bool = true;
          oauthToken: string = "";
          destinationPredefinedAcl: string = "authenticatedRead";
          userProject: string = ""; ifSourceMetagenerationNotMatch: string = "";
          ifGenerationMatch: string = ""; alt: string = "json"; userIp: string = "";
          ifGenerationNotMatch: string = ""; quotaUser: string = "";
          ifSourceGenerationNotMatch: string = "";
          ifMetagenerationMatch: string = ""; rewriteToken: string = "";
          sourceGeneration: string = ""; ifSourceMetagenerationMatch: string = "";
          body: JsonNode = nil; maxBytesRewrittenPerCall: string = "";
          provisionalUserProject: string = "";
          ifMetagenerationNotMatch: string = ""; projection: string = "full";
          fields: string = ""; destinationKmsKeyName: string = ""): Recallable =
  ## storageObjectsRewrite
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifSourceGenerationMatch: string
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   ifSourceMetagenerationNotMatch: string
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ifSourceGenerationNotMatch: string
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   sourceObject: string (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   rewriteToken: string
  ##               : Include this field (from the previous rewrite response) on each rewrite request after the first one, until the rewrite response 'done' flag is true. Calls that provide a rewriteToken can omit all other request fields, but if included those fields must match the values provided in the first rewrite request.
  ##   sourceGeneration: string
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   ifSourceMetagenerationMatch: string
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   sourceBucket: string (required)
  ##               : Name of the bucket in which to find the source object.
  ##   body: JObject
  ##   maxBytesRewrittenPerCall: string
  ##                           : The maximum number of bytes that will be rewritten per rewrite request. Most callers shouldn't need to specify this parameter - it is primarily in place to support testing. If specified the value must be an integral multiple of 1 MiB (1048576). Also, this only applies to requests where the source and destination span locations and/or storage classes. Finally, this value must not change across rewrite calls else you'll get an error that the rewriteToken is invalid.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   destinationKmsKeyName: string
  ##                        : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  var path_579847 = newJObject()
  var query_579848 = newJObject()
  var body_579849 = newJObject()
  add(query_579848, "key", newJString(key))
  add(query_579848, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_579848, "prettyPrint", newJBool(prettyPrint))
  add(query_579848, "oauth_token", newJString(oauthToken))
  add(path_579847, "destinationObject", newJString(destinationObject))
  add(query_579848, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_579848, "userProject", newJString(userProject))
  add(query_579848, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(path_579847, "destinationBucket", newJString(destinationBucket))
  add(query_579848, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_579848, "alt", newJString(alt))
  add(query_579848, "userIp", newJString(userIp))
  add(query_579848, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_579848, "quotaUser", newJString(quotaUser))
  add(query_579848, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  add(path_579847, "sourceObject", newJString(sourceObject))
  add(query_579848, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_579848, "rewriteToken", newJString(rewriteToken))
  add(query_579848, "sourceGeneration", newJString(sourceGeneration))
  add(query_579848, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(path_579847, "sourceBucket", newJString(sourceBucket))
  if body != nil:
    body_579849 = body
  add(query_579848, "maxBytesRewrittenPerCall",
      newJString(maxBytesRewrittenPerCall))
  add(query_579848, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579848, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_579848, "projection", newJString(projection))
  add(query_579848, "fields", newJString(fields))
  add(query_579848, "destinationKmsKeyName", newJString(destinationKmsKeyName))
  result = call_579846.call(path_579847, query_579848, nil, nil, body_579849)

var storageObjectsRewrite* = Call_StorageObjectsRewrite_579814(
    name: "storageObjectsRewrite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/rewriteTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsRewrite_579815, base: "/storage/v1",
    url: url_StorageObjectsRewrite_579816, schemes: {Scheme.Https})
type
  Call_StorageChannelsStop_579850 = ref object of OpenApiRestCall_578355
proc url_StorageChannelsStop_579852(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageChannelsStop_579851(path: JsonNode; query: JsonNode;
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
  var valid_579853 = query.getOrDefault("key")
  valid_579853 = validateParameter(valid_579853, JString, required = false,
                                 default = nil)
  if valid_579853 != nil:
    section.add "key", valid_579853
  var valid_579854 = query.getOrDefault("prettyPrint")
  valid_579854 = validateParameter(valid_579854, JBool, required = false,
                                 default = newJBool(true))
  if valid_579854 != nil:
    section.add "prettyPrint", valid_579854
  var valid_579855 = query.getOrDefault("oauth_token")
  valid_579855 = validateParameter(valid_579855, JString, required = false,
                                 default = nil)
  if valid_579855 != nil:
    section.add "oauth_token", valid_579855
  var valid_579856 = query.getOrDefault("alt")
  valid_579856 = validateParameter(valid_579856, JString, required = false,
                                 default = newJString("json"))
  if valid_579856 != nil:
    section.add "alt", valid_579856
  var valid_579857 = query.getOrDefault("userIp")
  valid_579857 = validateParameter(valid_579857, JString, required = false,
                                 default = nil)
  if valid_579857 != nil:
    section.add "userIp", valid_579857
  var valid_579858 = query.getOrDefault("quotaUser")
  valid_579858 = validateParameter(valid_579858, JString, required = false,
                                 default = nil)
  if valid_579858 != nil:
    section.add "quotaUser", valid_579858
  var valid_579859 = query.getOrDefault("fields")
  valid_579859 = validateParameter(valid_579859, JString, required = false,
                                 default = nil)
  if valid_579859 != nil:
    section.add "fields", valid_579859
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

proc call*(call_579861: Call_StorageChannelsStop_579850; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_579861.validator(path, query, header, formData, body)
  let scheme = call_579861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579861.url(scheme.get, call_579861.host, call_579861.base,
                         call_579861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579861, url, valid)

proc call*(call_579862: Call_StorageChannelsStop_579850; key: string = "";
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
  var query_579863 = newJObject()
  var body_579864 = newJObject()
  add(query_579863, "key", newJString(key))
  add(query_579863, "prettyPrint", newJBool(prettyPrint))
  add(query_579863, "oauth_token", newJString(oauthToken))
  add(query_579863, "alt", newJString(alt))
  add(query_579863, "userIp", newJString(userIp))
  add(query_579863, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_579864 = resource
  add(query_579863, "fields", newJString(fields))
  result = call_579862.call(nil, query_579863, nil, nil, body_579864)

var storageChannelsStop* = Call_StorageChannelsStop_579850(
    name: "storageChannelsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_StorageChannelsStop_579851, base: "/storage/v1",
    url: url_StorageChannelsStop_579852, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysCreate_579885 = ref object of OpenApiRestCall_578355
proc url_StorageProjectsHmacKeysCreate_579887(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysCreate_579886(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new HMAC key for the specified service account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579888 = path.getOrDefault("projectId")
  valid_579888 = validateParameter(valid_579888, JString, required = true,
                                 default = nil)
  if valid_579888 != nil:
    section.add "projectId", valid_579888
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   serviceAccountEmail: JString (required)
  ##                      : Email address of the service account.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579889 = query.getOrDefault("key")
  valid_579889 = validateParameter(valid_579889, JString, required = false,
                                 default = nil)
  if valid_579889 != nil:
    section.add "key", valid_579889
  var valid_579890 = query.getOrDefault("prettyPrint")
  valid_579890 = validateParameter(valid_579890, JBool, required = false,
                                 default = newJBool(true))
  if valid_579890 != nil:
    section.add "prettyPrint", valid_579890
  var valid_579891 = query.getOrDefault("oauth_token")
  valid_579891 = validateParameter(valid_579891, JString, required = false,
                                 default = nil)
  if valid_579891 != nil:
    section.add "oauth_token", valid_579891
  var valid_579892 = query.getOrDefault("userProject")
  valid_579892 = validateParameter(valid_579892, JString, required = false,
                                 default = nil)
  if valid_579892 != nil:
    section.add "userProject", valid_579892
  var valid_579893 = query.getOrDefault("alt")
  valid_579893 = validateParameter(valid_579893, JString, required = false,
                                 default = newJString("json"))
  if valid_579893 != nil:
    section.add "alt", valid_579893
  var valid_579894 = query.getOrDefault("userIp")
  valid_579894 = validateParameter(valid_579894, JString, required = false,
                                 default = nil)
  if valid_579894 != nil:
    section.add "userIp", valid_579894
  var valid_579895 = query.getOrDefault("quotaUser")
  valid_579895 = validateParameter(valid_579895, JString, required = false,
                                 default = nil)
  if valid_579895 != nil:
    section.add "quotaUser", valid_579895
  assert query != nil, "query argument is necessary due to required `serviceAccountEmail` field"
  var valid_579896 = query.getOrDefault("serviceAccountEmail")
  valid_579896 = validateParameter(valid_579896, JString, required = true,
                                 default = nil)
  if valid_579896 != nil:
    section.add "serviceAccountEmail", valid_579896
  var valid_579897 = query.getOrDefault("fields")
  valid_579897 = validateParameter(valid_579897, JString, required = false,
                                 default = nil)
  if valid_579897 != nil:
    section.add "fields", valid_579897
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579898: Call_StorageProjectsHmacKeysCreate_579885; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new HMAC key for the specified service account.
  ## 
  let valid = call_579898.validator(path, query, header, formData, body)
  let scheme = call_579898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579898.url(scheme.get, call_579898.host, call_579898.base,
                         call_579898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579898, url, valid)

proc call*(call_579899: Call_StorageProjectsHmacKeysCreate_579885;
          projectId: string; serviceAccountEmail: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## storageProjectsHmacKeysCreate
  ## Creates a new HMAC key for the specified service account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID owning the service account.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   serviceAccountEmail: string (required)
  ##                      : Email address of the service account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579900 = newJObject()
  var query_579901 = newJObject()
  add(query_579901, "key", newJString(key))
  add(query_579901, "prettyPrint", newJBool(prettyPrint))
  add(query_579901, "oauth_token", newJString(oauthToken))
  add(path_579900, "projectId", newJString(projectId))
  add(query_579901, "userProject", newJString(userProject))
  add(query_579901, "alt", newJString(alt))
  add(query_579901, "userIp", newJString(userIp))
  add(query_579901, "quotaUser", newJString(quotaUser))
  add(query_579901, "serviceAccountEmail", newJString(serviceAccountEmail))
  add(query_579901, "fields", newJString(fields))
  result = call_579899.call(path_579900, query_579901, nil, nil, nil)

var storageProjectsHmacKeysCreate* = Call_StorageProjectsHmacKeysCreate_579885(
    name: "storageProjectsHmacKeysCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/projects/{projectId}/hmacKeys",
    validator: validate_StorageProjectsHmacKeysCreate_579886, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysCreate_579887, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysList_579865 = ref object of OpenApiRestCall_578355
proc url_StorageProjectsHmacKeysList_579867(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysList_579866(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of HMAC keys matching the criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Name of the project in which to look for HMAC keys.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579868 = path.getOrDefault("projectId")
  valid_579868 = validateParameter(valid_579868, JString, required = true,
                                 default = nil)
  if valid_579868 != nil:
    section.add "projectId", valid_579868
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   showDeletedKeys: JBool
  ##                  : Whether or not to show keys in the DELETED state.
  ##   serviceAccountEmail: JString
  ##                      : If present, only keys for the given service account are returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of items to return in a single page of responses. The service uses this parameter or 250 items, whichever is smaller. The max number of items per page will also be limited by the number of distinct service accounts in the response. If the number of service accounts in a single response is too high, the page will truncated and a next page token will be returned.
  section = newJObject()
  var valid_579869 = query.getOrDefault("key")
  valid_579869 = validateParameter(valid_579869, JString, required = false,
                                 default = nil)
  if valid_579869 != nil:
    section.add "key", valid_579869
  var valid_579870 = query.getOrDefault("prettyPrint")
  valid_579870 = validateParameter(valid_579870, JBool, required = false,
                                 default = newJBool(true))
  if valid_579870 != nil:
    section.add "prettyPrint", valid_579870
  var valid_579871 = query.getOrDefault("oauth_token")
  valid_579871 = validateParameter(valid_579871, JString, required = false,
                                 default = nil)
  if valid_579871 != nil:
    section.add "oauth_token", valid_579871
  var valid_579872 = query.getOrDefault("userProject")
  valid_579872 = validateParameter(valid_579872, JString, required = false,
                                 default = nil)
  if valid_579872 != nil:
    section.add "userProject", valid_579872
  var valid_579873 = query.getOrDefault("alt")
  valid_579873 = validateParameter(valid_579873, JString, required = false,
                                 default = newJString("json"))
  if valid_579873 != nil:
    section.add "alt", valid_579873
  var valid_579874 = query.getOrDefault("userIp")
  valid_579874 = validateParameter(valid_579874, JString, required = false,
                                 default = nil)
  if valid_579874 != nil:
    section.add "userIp", valid_579874
  var valid_579875 = query.getOrDefault("quotaUser")
  valid_579875 = validateParameter(valid_579875, JString, required = false,
                                 default = nil)
  if valid_579875 != nil:
    section.add "quotaUser", valid_579875
  var valid_579876 = query.getOrDefault("pageToken")
  valid_579876 = validateParameter(valid_579876, JString, required = false,
                                 default = nil)
  if valid_579876 != nil:
    section.add "pageToken", valid_579876
  var valid_579877 = query.getOrDefault("showDeletedKeys")
  valid_579877 = validateParameter(valid_579877, JBool, required = false, default = nil)
  if valid_579877 != nil:
    section.add "showDeletedKeys", valid_579877
  var valid_579878 = query.getOrDefault("serviceAccountEmail")
  valid_579878 = validateParameter(valid_579878, JString, required = false,
                                 default = nil)
  if valid_579878 != nil:
    section.add "serviceAccountEmail", valid_579878
  var valid_579879 = query.getOrDefault("fields")
  valid_579879 = validateParameter(valid_579879, JString, required = false,
                                 default = nil)
  if valid_579879 != nil:
    section.add "fields", valid_579879
  var valid_579880 = query.getOrDefault("maxResults")
  valid_579880 = validateParameter(valid_579880, JInt, required = false,
                                 default = newJInt(250))
  if valid_579880 != nil:
    section.add "maxResults", valid_579880
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579881: Call_StorageProjectsHmacKeysList_579865; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of HMAC keys matching the criteria.
  ## 
  let valid = call_579881.validator(path, query, header, formData, body)
  let scheme = call_579881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579881.url(scheme.get, call_579881.host, call_579881.base,
                         call_579881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579881, url, valid)

proc call*(call_579882: Call_StorageProjectsHmacKeysList_579865; projectId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          userProject: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; showDeletedKeys: bool = false;
          serviceAccountEmail: string = ""; fields: string = ""; maxResults: int = 250): Recallable =
  ## storageProjectsHmacKeysList
  ## Retrieves a list of HMAC keys matching the criteria.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Name of the project in which to look for HMAC keys.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   showDeletedKeys: bool
  ##                  : Whether or not to show keys in the DELETED state.
  ##   serviceAccountEmail: string
  ##                      : If present, only keys for the given service account are returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of items to return in a single page of responses. The service uses this parameter or 250 items, whichever is smaller. The max number of items per page will also be limited by the number of distinct service accounts in the response. If the number of service accounts in a single response is too high, the page will truncated and a next page token will be returned.
  var path_579883 = newJObject()
  var query_579884 = newJObject()
  add(query_579884, "key", newJString(key))
  add(query_579884, "prettyPrint", newJBool(prettyPrint))
  add(query_579884, "oauth_token", newJString(oauthToken))
  add(path_579883, "projectId", newJString(projectId))
  add(query_579884, "userProject", newJString(userProject))
  add(query_579884, "alt", newJString(alt))
  add(query_579884, "userIp", newJString(userIp))
  add(query_579884, "quotaUser", newJString(quotaUser))
  add(query_579884, "pageToken", newJString(pageToken))
  add(query_579884, "showDeletedKeys", newJBool(showDeletedKeys))
  add(query_579884, "serviceAccountEmail", newJString(serviceAccountEmail))
  add(query_579884, "fields", newJString(fields))
  add(query_579884, "maxResults", newJInt(maxResults))
  result = call_579882.call(path_579883, query_579884, nil, nil, nil)

var storageProjectsHmacKeysList* = Call_StorageProjectsHmacKeysList_579865(
    name: "storageProjectsHmacKeysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/projects/{projectId}/hmacKeys",
    validator: validate_StorageProjectsHmacKeysList_579866, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysList_579867, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysUpdate_579919 = ref object of OpenApiRestCall_578355
proc url_StorageProjectsHmacKeysUpdate_579921(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysUpdate_579920(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account of the updated key.
  ##   accessId: JString (required)
  ##           : Name of the HMAC key being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579922 = path.getOrDefault("projectId")
  valid_579922 = validateParameter(valid_579922, JString, required = true,
                                 default = nil)
  if valid_579922 != nil:
    section.add "projectId", valid_579922
  var valid_579923 = path.getOrDefault("accessId")
  valid_579923 = validateParameter(valid_579923, JString, required = true,
                                 default = nil)
  if valid_579923 != nil:
    section.add "accessId", valid_579923
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579924 = query.getOrDefault("key")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = nil)
  if valid_579924 != nil:
    section.add "key", valid_579924
  var valid_579925 = query.getOrDefault("prettyPrint")
  valid_579925 = validateParameter(valid_579925, JBool, required = false,
                                 default = newJBool(true))
  if valid_579925 != nil:
    section.add "prettyPrint", valid_579925
  var valid_579926 = query.getOrDefault("oauth_token")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = nil)
  if valid_579926 != nil:
    section.add "oauth_token", valid_579926
  var valid_579927 = query.getOrDefault("userProject")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "userProject", valid_579927
  var valid_579928 = query.getOrDefault("alt")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = newJString("json"))
  if valid_579928 != nil:
    section.add "alt", valid_579928
  var valid_579929 = query.getOrDefault("userIp")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "userIp", valid_579929
  var valid_579930 = query.getOrDefault("quotaUser")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "quotaUser", valid_579930
  var valid_579931 = query.getOrDefault("fields")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "fields", valid_579931
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

proc call*(call_579933: Call_StorageProjectsHmacKeysUpdate_579919; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ## 
  let valid = call_579933.validator(path, query, header, formData, body)
  let scheme = call_579933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579933.url(scheme.get, call_579933.host, call_579933.base,
                         call_579933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579933, url, valid)

proc call*(call_579934: Call_StorageProjectsHmacKeysUpdate_579919;
          projectId: string; accessId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## storageProjectsHmacKeysUpdate
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID owning the service account of the updated key.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accessId: string (required)
  ##           : Name of the HMAC key being updated.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579935 = newJObject()
  var query_579936 = newJObject()
  var body_579937 = newJObject()
  add(query_579936, "key", newJString(key))
  add(query_579936, "prettyPrint", newJBool(prettyPrint))
  add(query_579936, "oauth_token", newJString(oauthToken))
  add(path_579935, "projectId", newJString(projectId))
  add(query_579936, "userProject", newJString(userProject))
  add(query_579936, "alt", newJString(alt))
  add(query_579936, "userIp", newJString(userIp))
  add(query_579936, "quotaUser", newJString(quotaUser))
  add(path_579935, "accessId", newJString(accessId))
  if body != nil:
    body_579937 = body
  add(query_579936, "fields", newJString(fields))
  result = call_579934.call(path_579935, query_579936, nil, nil, body_579937)

var storageProjectsHmacKeysUpdate* = Call_StorageProjectsHmacKeysUpdate_579919(
    name: "storageProjectsHmacKeysUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysUpdate_579920, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysUpdate_579921, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysGet_579902 = ref object of OpenApiRestCall_578355
proc url_StorageProjectsHmacKeysGet_579904(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysGet_579903(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an HMAC key's metadata
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account of the requested key.
  ##   accessId: JString (required)
  ##           : Name of the HMAC key.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579905 = path.getOrDefault("projectId")
  valid_579905 = validateParameter(valid_579905, JString, required = true,
                                 default = nil)
  if valid_579905 != nil:
    section.add "projectId", valid_579905
  var valid_579906 = path.getOrDefault("accessId")
  valid_579906 = validateParameter(valid_579906, JString, required = true,
                                 default = nil)
  if valid_579906 != nil:
    section.add "accessId", valid_579906
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579907 = query.getOrDefault("key")
  valid_579907 = validateParameter(valid_579907, JString, required = false,
                                 default = nil)
  if valid_579907 != nil:
    section.add "key", valid_579907
  var valid_579908 = query.getOrDefault("prettyPrint")
  valid_579908 = validateParameter(valid_579908, JBool, required = false,
                                 default = newJBool(true))
  if valid_579908 != nil:
    section.add "prettyPrint", valid_579908
  var valid_579909 = query.getOrDefault("oauth_token")
  valid_579909 = validateParameter(valid_579909, JString, required = false,
                                 default = nil)
  if valid_579909 != nil:
    section.add "oauth_token", valid_579909
  var valid_579910 = query.getOrDefault("userProject")
  valid_579910 = validateParameter(valid_579910, JString, required = false,
                                 default = nil)
  if valid_579910 != nil:
    section.add "userProject", valid_579910
  var valid_579911 = query.getOrDefault("alt")
  valid_579911 = validateParameter(valid_579911, JString, required = false,
                                 default = newJString("json"))
  if valid_579911 != nil:
    section.add "alt", valid_579911
  var valid_579912 = query.getOrDefault("userIp")
  valid_579912 = validateParameter(valid_579912, JString, required = false,
                                 default = nil)
  if valid_579912 != nil:
    section.add "userIp", valid_579912
  var valid_579913 = query.getOrDefault("quotaUser")
  valid_579913 = validateParameter(valid_579913, JString, required = false,
                                 default = nil)
  if valid_579913 != nil:
    section.add "quotaUser", valid_579913
  var valid_579914 = query.getOrDefault("fields")
  valid_579914 = validateParameter(valid_579914, JString, required = false,
                                 default = nil)
  if valid_579914 != nil:
    section.add "fields", valid_579914
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579915: Call_StorageProjectsHmacKeysGet_579902; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an HMAC key's metadata
  ## 
  let valid = call_579915.validator(path, query, header, formData, body)
  let scheme = call_579915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579915.url(scheme.get, call_579915.host, call_579915.base,
                         call_579915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579915, url, valid)

proc call*(call_579916: Call_StorageProjectsHmacKeysGet_579902; projectId: string;
          accessId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## storageProjectsHmacKeysGet
  ## Retrieves an HMAC key's metadata
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID owning the service account of the requested key.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accessId: string (required)
  ##           : Name of the HMAC key.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579917 = newJObject()
  var query_579918 = newJObject()
  add(query_579918, "key", newJString(key))
  add(query_579918, "prettyPrint", newJBool(prettyPrint))
  add(query_579918, "oauth_token", newJString(oauthToken))
  add(path_579917, "projectId", newJString(projectId))
  add(query_579918, "userProject", newJString(userProject))
  add(query_579918, "alt", newJString(alt))
  add(query_579918, "userIp", newJString(userIp))
  add(query_579918, "quotaUser", newJString(quotaUser))
  add(path_579917, "accessId", newJString(accessId))
  add(query_579918, "fields", newJString(fields))
  result = call_579916.call(path_579917, query_579918, nil, nil, nil)

var storageProjectsHmacKeysGet* = Call_StorageProjectsHmacKeysGet_579902(
    name: "storageProjectsHmacKeysGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysGet_579903, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysGet_579904, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysDelete_579938 = ref object of OpenApiRestCall_578355
proc url_StorageProjectsHmacKeysDelete_579940(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysDelete_579939(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an HMAC key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the requested key
  ##   accessId: JString (required)
  ##           : Name of the HMAC key to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579941 = path.getOrDefault("projectId")
  valid_579941 = validateParameter(valid_579941, JString, required = true,
                                 default = nil)
  if valid_579941 != nil:
    section.add "projectId", valid_579941
  var valid_579942 = path.getOrDefault("accessId")
  valid_579942 = validateParameter(valid_579942, JString, required = true,
                                 default = nil)
  if valid_579942 != nil:
    section.add "accessId", valid_579942
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579943 = query.getOrDefault("key")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "key", valid_579943
  var valid_579944 = query.getOrDefault("prettyPrint")
  valid_579944 = validateParameter(valid_579944, JBool, required = false,
                                 default = newJBool(true))
  if valid_579944 != nil:
    section.add "prettyPrint", valid_579944
  var valid_579945 = query.getOrDefault("oauth_token")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "oauth_token", valid_579945
  var valid_579946 = query.getOrDefault("userProject")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "userProject", valid_579946
  var valid_579947 = query.getOrDefault("alt")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = newJString("json"))
  if valid_579947 != nil:
    section.add "alt", valid_579947
  var valid_579948 = query.getOrDefault("userIp")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "userIp", valid_579948
  var valid_579949 = query.getOrDefault("quotaUser")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "quotaUser", valid_579949
  var valid_579950 = query.getOrDefault("fields")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "fields", valid_579950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579951: Call_StorageProjectsHmacKeysDelete_579938; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an HMAC key.
  ## 
  let valid = call_579951.validator(path, query, header, formData, body)
  let scheme = call_579951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579951.url(scheme.get, call_579951.host, call_579951.base,
                         call_579951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579951, url, valid)

proc call*(call_579952: Call_StorageProjectsHmacKeysDelete_579938;
          projectId: string; accessId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userProject: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## storageProjectsHmacKeysDelete
  ## Deletes an HMAC key.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID owning the requested key
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accessId: string (required)
  ##           : Name of the HMAC key to be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579953 = newJObject()
  var query_579954 = newJObject()
  add(query_579954, "key", newJString(key))
  add(query_579954, "prettyPrint", newJBool(prettyPrint))
  add(query_579954, "oauth_token", newJString(oauthToken))
  add(path_579953, "projectId", newJString(projectId))
  add(query_579954, "userProject", newJString(userProject))
  add(query_579954, "alt", newJString(alt))
  add(query_579954, "userIp", newJString(userIp))
  add(query_579954, "quotaUser", newJString(quotaUser))
  add(path_579953, "accessId", newJString(accessId))
  add(query_579954, "fields", newJString(fields))
  result = call_579952.call(path_579953, query_579954, nil, nil, nil)

var storageProjectsHmacKeysDelete* = Call_StorageProjectsHmacKeysDelete_579938(
    name: "storageProjectsHmacKeysDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysDelete_579939, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysDelete_579940, schemes: {Scheme.Https})
type
  Call_StorageProjectsServiceAccountGet_579955 = ref object of OpenApiRestCall_578355
proc url_StorageProjectsServiceAccountGet_579957(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/serviceAccount")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsServiceAccountGet_579956(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the email address of this project's Google Cloud Storage service account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579958 = path.getOrDefault("projectId")
  valid_579958 = validateParameter(valid_579958, JString, required = true,
                                 default = nil)
  if valid_579958 != nil:
    section.add "projectId", valid_579958
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579959 = query.getOrDefault("key")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "key", valid_579959
  var valid_579960 = query.getOrDefault("prettyPrint")
  valid_579960 = validateParameter(valid_579960, JBool, required = false,
                                 default = newJBool(true))
  if valid_579960 != nil:
    section.add "prettyPrint", valid_579960
  var valid_579961 = query.getOrDefault("oauth_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "oauth_token", valid_579961
  var valid_579962 = query.getOrDefault("userProject")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "userProject", valid_579962
  var valid_579963 = query.getOrDefault("alt")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("json"))
  if valid_579963 != nil:
    section.add "alt", valid_579963
  var valid_579964 = query.getOrDefault("userIp")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "userIp", valid_579964
  var valid_579965 = query.getOrDefault("quotaUser")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "quotaUser", valid_579965
  var valid_579966 = query.getOrDefault("provisionalUserProject")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "provisionalUserProject", valid_579966
  var valid_579967 = query.getOrDefault("fields")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "fields", valid_579967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579968: Call_StorageProjectsServiceAccountGet_579955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the email address of this project's Google Cloud Storage service account.
  ## 
  let valid = call_579968.validator(path, query, header, formData, body)
  let scheme = call_579968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579968.url(scheme.get, call_579968.host, call_579968.base,
                         call_579968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579968, url, valid)

proc call*(call_579969: Call_StorageProjectsServiceAccountGet_579955;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProject: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          provisionalUserProject: string = ""; fields: string = ""): Recallable =
  ## storageProjectsServiceAccountGet
  ## Get the email address of this project's Google Cloud Storage service account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579970 = newJObject()
  var query_579971 = newJObject()
  add(query_579971, "key", newJString(key))
  add(query_579971, "prettyPrint", newJBool(prettyPrint))
  add(query_579971, "oauth_token", newJString(oauthToken))
  add(path_579970, "projectId", newJString(projectId))
  add(query_579971, "userProject", newJString(userProject))
  add(query_579971, "alt", newJString(alt))
  add(query_579971, "userIp", newJString(userIp))
  add(query_579971, "quotaUser", newJString(quotaUser))
  add(query_579971, "provisionalUserProject", newJString(provisionalUserProject))
  add(query_579971, "fields", newJString(fields))
  result = call_579969.call(path_579970, query_579971, nil, nil, nil)

var storageProjectsServiceAccountGet* = Call_StorageProjectsServiceAccountGet_579955(
    name: "storageProjectsServiceAccountGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/projects/{projectId}/serviceAccount",
    validator: validate_StorageProjectsServiceAccountGet_579956,
    base: "/storage/v1", url: url_StorageProjectsServiceAccountGet_579957,
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
